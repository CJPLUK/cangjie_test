/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: cjHeapSize=16gb %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color| compare %f
// ASSERT: scan PASSED: 8

import stdx.unittest.concurrent.*
import std.sync.AtomicInt64
import std.collection.concurrent.ConcurrentLinkedQueue


var counter = 0
@Test
class SequentialSpecTests {
    @TestCase
    func testAtomicCounterSequential(): Unit {
        let counter = AtomicInt64(0)
        
        let result = scenario("atomic_counter_seq")
            .actor({ => counter.fetchAdd(1) })
            .actor({ => counter.fetchSub(1) })
            .sequentialSpec<AtomicInt64>(
                { => AtomicInt64(0) },
                { state: AtomicInt64, inv: OperationInvocation =>
                    if (inv.actorId == 0) {
                        execResultOf<Int64>({ => state.fetchAdd(1) })
                    } else {
                        execResultOf<Int64>({ => state.fetchSub(1) })
                    }
                }
            )
            .iterations(10)
            .build()
            .run()
        
        println(result.report())
        @Assert(result.passed)
    }

    @TestCase
    func testAtomicCounterAutoSpec(): Unit {
        let counter = AtomicInt64(0)
        
        let result = scenario("atomic_counter_default_seq")
            .reset { => counter.store(0) }
            .actor({ => counter.fetchAdd(1) })
            .actor({ => counter.fetchSub(1) })
            .iterations(10)
            .build()
            .run()
        
        println(result.report())
        @Assert(result.passed)
    }


    @TestCase
    func testDataRaceCounterSequential(): Unit {
        
        let result = scenario("counter_data_race")
            .reset { => counter = 0 }
            .actor({ => counter += 1; counter })
            .actor({ => counter -= 1; counter })
            .iterations(1000)
            .build()
            .run()
        
        println(result.report())
        @Assert(!result.passed)
    }

    
    @TestCase
    func testTechnicallyDataRaceButPasses(): Unit {
        
        let result = scenario("counter_data_race_but_passes")
            .reset { => counter = 0 }
            .actor({ => for (_ in 0..100) { counter += blackBox(1) } })
            .actor({ => 
                var prev = 0
                for (_ in 0..100) { 
                    // technically this can fail due to data race, but in practice it should always pass 
                    // due to how compiler currently works and how most hardware handles memory operations, 
                    // and the test is designed to detect when this behavior changes
                    @Assert(counter >= prev) 
                    prev = counter
                }
            })
            .iterations(1000)
            .build()
            .run()
        
        println(result.report())
        @Assert(result.passed)
    }

    @TestCase
    func testDataRaceCounterMultiOp(): Unit {   
        let result = scenario("atomic_counter_seq_multi")
            .reset { => 
                counter = 0
            }
            .actorWithOps([
                operation("1", { => counter = 0 }),      
                operation("2", { => 
                    // this is just for the test reliablity, 
                    for (_ in 0..100) {
                        counter = blackBox(1) 
                    }
                    counter = blackBox(0) 
                }),      
                operation("3", { => counter = 0 }),
            ])
            .actor({ => counter })
            .iterations(1000)
            .build()
            .run()
        
        println(result.report())
        @Assert(!result.passed)
    }

    @TestCase
    func testSequentialError(): Unit {
        let counter = AtomicInt64(0)
        
        let result = scenario("atomic_counter_error")
            .actor({ => counter.fetchAdd(1) })
            .actor({ => counter.fetchSub(1) })
            .sequentialSpec<AtomicInt64>(
                { => AtomicInt64(2) },
                { state: AtomicInt64, inv: OperationInvocation =>
                    if (inv.actorId == 0) {
                        execResultOf<Int64>({ => state.fetchAdd(1) })
                    } else {
                        execResultOf<Int64>({ => state.fetchSub(1) })
                    }
                }
            )
            .iterations(10)
            .build() 
            .run()
        
        println(result.report())
        @Assert(!result.passed)
    }
    
    @TestCase
    func testQueueWithMultipleOperations(): Unit {
        
        let queue = ConcurrentLinkedQueue<Int64>()
        
        let result = scenario("queue_multi_ops")
            .actor({ => if (queue.add(1)) { 1 } else { 0 } })
            .actor({ => queue.remove() ?? -1 })
            .sequentialSpec<ConcurrentLinkedQueue<Int64>>(
                { => ConcurrentLinkedQueue<Int64>() },
                { state: ConcurrentLinkedQueue<Int64>, inv: OperationInvocation =>
                    if (inv.actorId == 0) {
                        execResultOf<Int64>({ => if (state.add(1)) { 1 } else { 0 } })
                    } else {
                        execResultOf<Int64>({ => state.remove() ?? -1 })
                    }
                }
            )
            .iterations(10)
            .build()
            .run()
        
        println(result.report())
        @Assert(result.passed)
    }

    var queue = ConcurrentLinkedQueue<Int64>()
    @TestCase
    func testQueueWithMultipleOperations2(): Unit {
        let result = scenario("queue_multi_ops3")
            .reset { => 
                queue = ConcurrentLinkedQueue<Int64>()         
            }
            .actorWithOps([
                operation("add", { => queue.add(1) }),
                operation("add", { => queue.add(2) }),
                operation("add", { => queue.add(3) }),
                operation("add", { => queue.add(4) }),
            ])
            .actorWithOps([
                operation("add", { => queue.add(10) }),
                operation("add", { => queue.add(20) }),
                operation("add", { => queue.add(30) }),
                operation("add", { => queue.add(40) }),
            ])
            .actorWithOps([
                operation("remove", { => queue.remove() ?? -1 }),
                operation("remove", { => queue.remove() ?? -1 }),
                operation("remove", { => queue.remove() ?? -1 }),
            ])
            .iterations(1000)
            .build()
            .run()
        
        println(result.report())
        @Assert(result.passed)
    }
}