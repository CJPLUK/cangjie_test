/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: this file MUST be compiled with --cj-pct — it pins the timeout
// validation parity between the stdx.unittest.sync mirror and real
// std.sync: a timed wait whose timeout is at or below `Duration.Zero`
// is rejected up front with std's exact IllegalArgumentException
// (BEFORE any coordinator interaction — the mediated path would
// otherwise map such a timeout onto a benign already-passed deadline),
// on both the Monitor wait queue and a Condition obtained from
// Mutex.condition(). A correct short timed wait still completes
// benignly through the virtual clock on both queues (the timeout is a
// deterministic Timer event, the lock is re-held per Mesa, and the
// iteration passes).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 4

// ASSERT: scan monitor_zero_wait
// ASSERT: scan Duration.Zero
// ASSERT: scan cond_zero_wait

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctTimeoutParityTests {
    /// An actor holding a Monitor and calling wait with a zero timeout:
    /// the wrapper rejects the timeout before any dispatch, so the
    /// IllegalArgumentException unwinds the actor's operation and fails
    /// the iteration with std's message — instead of the mediated path
    /// returning a normal timed-out result.
    @TestCase
    func test_pct_timeout_monitor_zero(): Unit {
        println("Testing PCT timeout parity (Monitor.wait, zero timeout)...")

        let mon = Monitor()

        let result = scenario("pct_timeout_monitor_zero")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(3301u64)
            .actor("monitor_zero_wait") {
                mon.lock()
                mon.wait(timeout: Duration.Zero) // <= Duration.Zero: rejected up front
                mon.unlock()
                0
            }
            .actor {
                0
            }
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.pctSchedule.isSome())
        let reportText = result.report().toString()
        println(reportText)
        @Assert(reportText.contains("monitor_zero_wait"))
        @Assert(reportText.contains("Duration.Zero"))
    }

    /// The same rejection through a Condition from Mutex.condition():
    /// the actor locks the owner mutex, then calls the timed wait with
    /// a zero timeout — the IllegalArgumentException surfaces the same
    /// way (the actor's operation result, the iteration's failure).
    @TestCase
    func test_pct_timeout_condition_zero(): Unit {
        println("Testing PCT timeout parity (Condition.wait, zero timeout)...")

        let mx = Mutex()
        mx.lock()
        let cond = mx.condition()
        mx.unlock()

        let result = scenario("pct_timeout_condition_zero")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(3302u64)
            .actor("cond_zero_wait") {
                mx.lock()
                cond.wait(timeout: Duration.Zero) // <= Duration.Zero: rejected up front
                mx.unlock()
                0
            }
            .actor {
                0
            }
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.pctSchedule.isSome())
        let reportText = result.report().toString()
        println(reportText)
        @Assert(reportText.contains("cond_zero_wait"))
        @Assert(reportText.contains("Duration.Zero"))
    }

    /// Control: a correct short timed Monitor.wait inside a scenario
    /// times out benignly — the virtual clock arms the deadline, the
    /// expiry is one deterministic Timer event, the wait returns false
    /// with the lock re-held (Mesa), and the iteration passes.
    @TestCase
    func test_pct_timeout_monitor_short_control(): Unit {
        println("Testing PCT timeout parity (Monitor.wait, short timeout control)...")

        let m = Monitor()

        let result = scenario("pct_timeout_monitor_short")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(3303u64)
            .actor {
                m.lock()
                let ok = m.wait(timeout: Duration.millisecond * 5)
                m.unlock()
                if (ok) {
                    -1
                } else {
                    0
                }
            }
            .actor {
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var timers = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Timer => timers++
                case _ => ()
            }
        }
        @Assert(timers == 1)
    }

    /// Control: the same benign short timed wait through a Condition
    /// from Mutex.condition() — the mediated condition wait arms the
    /// virtual deadline, times out as one Timer event with the owner
    /// lock re-held, and the iteration passes.
    @TestCase
    func test_pct_timeout_condition_short_control(): Unit {
        println("Testing PCT timeout parity (Condition.wait, short timeout control)...")

        let mx = Mutex()
        mx.lock()
        let cond = mx.condition()
        mx.unlock()

        let result = scenario("pct_timeout_condition_short")
            .mode(PCT)
            .priorityChangePoints(0)
            .iterations(1)
            .pctSeed(3304u64)
            .actor {
                mx.lock()
                let ok = cond.wait(timeout: Duration.millisecond * 5)
                mx.unlock()
                if (ok) {
                    -1
                } else {
                    0
                }
            }
            .actor {
                0
            }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var timers = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Timer => timers++
                case _ => ()
            }
        }
        @Assert(timers == 1)
    }
}
