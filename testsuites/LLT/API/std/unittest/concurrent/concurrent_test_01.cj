/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

import stdx.unittest.concurrent.*
import std.sync.*
import std.collection.concurrent.*

@Test
class ConcurrentTests {
    @TestCase
    func test_basic_atomic_counter(): Unit {
        println("Testing basic atomic counter scenario...")
        
        let counter = AtomicInt64(0)
        
        let result = scenario("basic_counter_test")
            .iterations(10)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()
        
        @Assert(result.passed)
    }


    var counter = 0
    @TestCase // might be flaky 
    func test_basic_counter_data_race(): Unit {
        println("Testing basic counter data race scenario...")
                
        let result = scenario("basic_counter_test")
            .iterations(1000)
            .actor { => for (j in 0..1000) { counter += 1 } }
            .actor { => for (j in 0..1000) { counter -= 1 } }
            .verify { => counter == 0 }
            .build()
            .run()
        
        @Assert(!result.passed)
    }

    @TestCase // might be flaky 
    func test_basic_counter_data_race2(): Unit {
        println("Testing basic counter data race scenario...")
        counter = 0        
        
        let result = scenario("basic_counter_test")
            .iterations(100000)
            .actor { => counter += 1 }
            .actor { => counter -= 1 }
            .verify { => counter == 0 }
            .build()
            .run()
        
        @Assert(!result.passed)
    }

    @TestCase
    func test_order_variability(): Unit {
        println("Testing that execution order varies sufficiently...")
        
        let iterations = 10
        let queue = ConcurrentLinkedQueue<Int64>()
        
        let result = scenario("queue_test")
            .iterations(iterations)
            .actor { => queue.add(1) }
            .actor { => queue.add(2) }
            .build()
            .run()

        let values = queue.toArray()
        @Assert(values.size == iterations * 2)
        
        @PowerAssert(values != [1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2])
        @PowerAssert(values != [2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1])
        
        @Assert(result.passed)
    }
}