/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 5

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

class DporBox {
    public var value: Int64 = 0
}

class DporLostUpdateState {
    public var counter: Int64 = 0
    public var tmp: Int64 = 0
    public let m: Mutex = Mutex()
}

@Test
class DporTests {
    /// A lost update reachable only through lock-ordered schedules: the
    /// split read-modify-write races with the whole-modify under the mutex.
    /// DPOR must explore the dependent segment orders, find the failing
    /// schedule, and stop (the first-failure semantics).
    @TestCase
    func test_dpor_finds_lost_update(): Unit {
        println("Testing that DPOR finds a lock-ordered lost update...")

        let result = scenario("dpor_lost_update")
            .mode(DPOR)
            .iterations(100)
            .withState { => DporLostUpdateState() }
            .actorWithOps([
                operation<Int64, DporLostUpdateState>("read") { s =>
                    s.m.lock()
                    s.tmp = s.counter
                    s.m.unlock()
                    0
                },
                operation<Int64, DporLostUpdateState>("write") { s =>
                    s.m.lock()
                    s.counter = s.tmp + 1
                    s.m.unlock()
                    0
                }
            ])
            .actorWithOps([
                operation<Int64, DporLostUpdateState>("rmw") { s =>
                    s.m.lock()
                    s.counter = s.counter + 1
                    s.m.unlock()
                    0
                }
            ])
            .verify { s => s.counter == 2 }
            .build()
            .run()

        let dpor = result.dporReport
        @Assert(dpor.isSome())
        @Assert(!result.passed)
        if (let Some(d) <- dpor) {
            @Assert(d.schedulesExplored >= 2)
            @Assert(pctEvents(d.lastSchedule).size > 0)
        }
    }

    /// A race-free scenario under correct locking passes AND the
    /// dependency-driven exploration exhausts (every lock-ordered
    /// interleaving covered within the budget).
    @TestCase
    func test_dpor_clean_scenario_exhausts(): Unit {
        println("Testing that a locked scenario exhausts DPOR...")

        let result = scenario("dpor_clean_locks")
            .mode(DPOR)
            .iterations(100)
            .withState { => DporLostUpdateState() }
            .actorWithOps([
                operation<Int64, DporLostUpdateState>("rmw1") { s =>
                    s.m.lock()
                    s.counter = s.counter + 1
                    s.m.unlock()
                    0
                }
            ])
            .actorWithOps([
                operation<Int64, DporLostUpdateState>("rmw2") { s =>
                    s.m.lock()
                    s.counter = s.counter + 1
                    s.m.unlock()
                    0
                }
            ])
            .verify { s => s.counter == 2 }
            .build()
            .run()

        let dpor = result.dporReport
        @Assert(dpor.isSome())
        @Assert(result.passed)
        if (let Some(d) <- dpor) {
            @Assert(d.exhausted)
            @Assert(d.schedulesExplored >= 1)
            @Assert(!d.deadlocked)
        }
    }

    /// The dependency oracle in action: two actors on the SAME atomic
    /// are dependent — both orders explored; two actors on DISJOINT
    /// atomics are independent — exactly one schedule (the partial
    /// order reduction).
    @TestCase
    func test_dpor_dependency_reduction(): Unit {
        println("Testing DPOR dependency-driven reduction...")

        let shared = AtomicInt64(0)
        let same = scenario("dpor_dep_same_atomic")
            .mode(DPOR)
            .iterations(50)
            .actorWithOps([operation<Int64>("w1") { =>
                let _ = shared.fetchAdd(1)
                0
            }])
            .actorWithOps([operation<Int64>("w2") { =>
                let _ = shared.fetchAdd(1)
                0
            }])
            .build()
            .run()
        let r1 = same.dporReport.getOrThrow()
        println("Same atomic: schedules=${r1.schedulesExplored} exhausted=${r1.exhausted}")
        @Assert(r1.schedulesExplored >= 2)
        @Assert(r1.exhausted)

        let a = AtomicInt64(0)
        let b = AtomicInt64(0)
        let disjoint = scenario("dpor_dep_disjoint")
            .mode(DPOR)
            .iterations(50)
            .actorWithOps([operation<Int64>("pa") { =>
                let _ = a.fetchAdd(1)
                0
            }])
            .actorWithOps([operation<Int64>("pb") { =>
                let _ = b.fetchAdd(1)
                0
            }])
            .build()
            .run()
        let r2 = disjoint.dporReport.getOrThrow()
        println("Disjoint: schedules=${r2.schedulesExplored} exhausted=${r2.exhausted}")
        @Assert(r2.schedulesExplored == 1)
        @Assert(r2.exhausted)
    }

    /// Mutex-mediated critical sections are dependent (every uncontended
    /// acquire/release notes the lock key): the exploration covers both
    /// orders of the two critical sections.
    @TestCase
    func test_dpor_mutex_orders_explored(): Unit {
        println("Testing that DPOR explores mutex-ordered critical sections...")

        let m = Mutex()
        let shared = DporBox()
        let result = scenario("dpor_mutex_orders")
            .mode(DPOR)
            .iterations(50)
            .actorWithOps([operation<Int64>("inc") { =>
                m.lock()
                shared.value += 1
                m.unlock()
                0
            }])
            .actorWithOps([operation<Int64>("dec") { =>
                m.lock()
                shared.value -= 1
                m.unlock()
                0
            }])
            .build()
            .run()
        let r = result.dporReport.getOrThrow()
        println("Mutex orders: schedules=${r.schedulesExplored} exhausted=${r.exhausted}")
        @Assert(r.schedulesExplored >= 2)
        @Assert(r.exhausted)
    }

    /// The scenario-level plumbing: the DPOR report surfaces through
    /// ScenarioResult.dporReport, the failing schedule through
    /// ScenarioResult.pctSchedule, and the rendered report carries the
    /// exploration line.
    @TestCase
    func test_dpor_scenario_result_surfacing(): Unit {
        println("Testing DPOR result surfacing...")

        let result = scenario("dpor_surfacing")
            .mode(DPOR)
            .iterations(10)
            .withState { => DporBox() }
            .actor { s: DporBox => s.value += 1 }
            .actor { s: DporBox => s.value -= 1 }
            .verify { s => s.value == 0 }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.dporReport.isSome())
        @Assert(result.pctSchedule.isSome())
        let text = result.report().toString()
        @Assert(text.contains("dpor_surfacing"))
        if (let Some(d) <- result.dporReport) {
            @Assert(d.stats.contains("schedules="))
            @Assert(d.schedulesExplored >= 1)
        }
    }
}
