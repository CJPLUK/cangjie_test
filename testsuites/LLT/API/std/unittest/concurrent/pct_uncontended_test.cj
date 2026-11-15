/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it verifies that
// uncontended lock acquisition stays invisible to the PCT scheduler
// (stdx.unittest.sync probes with tryLock before wrapping) while contended
// rendezvous still work, and that actor-visible state stays deterministic.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 3

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctUncontendedTests {
    /// Uncontended locks must not produce Block events (the tryLock probe
    /// keeps the fast path out of the scheduler's view), so a scenario whose
    /// actors only take uncontended locks records no Deadlock and no
    /// deadlock-recovery Resume events, while atomics still provide grid
    /// points for schedule exploration.
    @TestCase
    func test_pct_uncontended_no_false_blocks(): Unit {
        println("Testing PCT uncontended lock probe transparency...")

        let counter = AtomicInt64(0)

        let result = scenario("pct_uncontended_transparent")
            .mode(PCT)
            .iterations(1)
            .actor {
                let m = Mutex()
                synchronized(m) {
                    counter.fetchAdd(1)
                }
                counter.fetchAdd(1)
            }
            .actor {
                let m = Mutex()
                m.lock()
                counter.fetchAdd(1)
                m.unlock()
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var sawDeadlock = false
        var sawResume = false
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Deadlock => sawDeadlock = true
                case Resume => sawResume = true
                case _ => ()
            }
        }
        @Assert(!sawDeadlock)
        @Assert(!sawResume)
        @Assert(counter.load() == 3)
    }

    /// Across several independent PCT iterations, every actor operation
    /// completes: the shared counter invariant holds after each iteration
    /// (no lost or duplicated operations regardless of the explored
    /// schedule).
    @TestCase
    func test_pct_uncontended_counter_invariants(): Unit {
        println("Testing PCT uncontended counter invariants across iterations...")

        let counter = AtomicInt64(0)
        let incrementsPerActor = 50

        let result = scenario("pct_uncontended_invariants")
            .mode(PCT)
            .iterations(3)
            .actor {
                let m = Mutex()
                for (_ in 0..incrementsPerActor) {
                    m.lock()
                    counter.fetchAdd(1)
                    m.unlock()
                }
            }
            .actor {
                let m = Mutex()
                for (_ in 0..incrementsPerActor) {
                    m.lock()
                    counter.fetchAdd(1)
                    m.unlock()
                }
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(counter.load() == Int64(3 * 2 * incrementsPerActor))
    }

    /// A contended mutex (the slow path does produce Block/Wake events) must
    /// still serialize the two actors: the critical-section history shows no
    /// overlap. This pins the wrapped slow path that the probe guards.
    @TestCase
    func test_pct_contended_mutex_serializes(): Unit {
        println("Testing PCT contended mutex serialization...")

        let m = Mutex()
        let inSection = AtomicInt64(0)
        let violations = AtomicInt64(0)

        let result = scenario("pct_contended_serialization")
            .mode(PCT)
            .iterations(2)
            .actor {
                for (_ in 0..20) {
                    m.lock()
                    let cur = inSection.fetchAdd(1)
                    if (cur != 0) {
                        violations.fetchAdd(1)
                    }
                    inSection.fetchAdd(-1)
                    m.unlock()
                }
            }
            .actor {
                for (_ in 0..20) {
                    m.lock()
                    let cur = inSection.fetchAdd(1)
                    if (cur != 0) {
                        violations.fetchAdd(1)
                    }
                    inSection.fetchAdd(-1)
                    m.unlock()
                }
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(violations.load() == 0)
    }
}
