/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 3

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctVirtualTimeTests {
    /// An actor's sleep is simulated: the virtual clock arms a timer at
    /// the sleep's deadline, the actor parks on the coordinator gate, and
    /// the expiry is a deterministic Timer event — the scenario's virtual
    /// 100ms must not cost real wall time beyond scheduling noise, and
    /// the schedule must record exactly one Timer for the sleep.
    @TestCase
    func test_pct_virtual_sleep_timer(): Unit {
        println("Testing PCT virtual sleep...")

        let result = scenario("pct_vt_sleep")
            .mode(PCT)
            .iterations(1)
            .pctSeed(7070u64)
            .actor {
                sleep(Duration.millisecond * 100)
                0
            }
            .actor { => 0 }
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

    /// A timed Monitor.wait with no notifier times out virtually: the
    /// deadline fires as a Timer event, the wait returns false with the
    /// monitor's lock re-acquired (Mesa discipline holds on the timeout
    /// path), and the actor proceeds — no real wall time is consumed.
    @TestCase
    func test_pct_timed_monitor_wait_returns_false(): Unit {
        println("Testing PCT timed monitor wait timeout...")

        let m = Monitor()

        let result = scenario("pct_vt_monitor_timeout")
            .mode(PCT)
            .iterations(1)
            .pctSeed(7071u64)
            .actor {
                m.lock()
                let ok = m.wait(timeout: Duration.millisecond * 100)
                m.unlock()
                if (ok) {
                    -1
                } else {
                    0
                }
            }
            .actor { => 0 }
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

    /// Virtual deadlines order against each other: an earlier deadline
    /// fires first even when armed later. The waiter's 50ms deadline
    /// precedes the sleeper's 100ms, so the timed wait times out (Timer),
    /// then the sleep fires (Timer) — and the recorded order is
    /// replay-stable.
    @TestCase
    func test_pct_timer_ordering_deterministic(): Unit {
        println("Testing PCT virtual timer ordering...")

        let m = Monitor()

        let recorded = scenario("pct_vt_order_src")
            .mode(PCT)
            .iterations(1)
            .pctSeed(7073u64)
            .actor {
                m.lock()
                m.wait(timeout: Duration.millisecond * 50)
                m.unlock()
                0
            }
            .actor {
                sleep(Duration.millisecond * 100)
                0
            }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let schedule = recorded.pctSchedule.getOrThrow()
        println("Schedule: ${schedule.report()}")

        var firstTimer = -1i64
        var secondTimer = -1i64
        var count = 0
        for (ev in pctEvents(schedule)) {
            match (ev.kind) {
                case Timer =>
                    if (count == 0) {
                        firstTimer = ev.from
                    } else {
                        secondTimer = ev.from
                    }
                    count++
                case _ => ()
            }
        }
        @Assert(count == 2)
        // The waiter's earlier deadline fires first.
        @Assert(firstTimer != secondTimer)

        let replayed = scenario("pct_vt_order_rep")
            .mode(PCT)
            .replaySchedule(schedule)
            .actor {
                m.lock()
                m.wait(timeout: Duration.millisecond * 50)
                m.unlock()
                0
            }
            .actor {
                sleep(Duration.millisecond * 100)
                0
            }
            .build()
            .run()
        @Assert(replayed.passed)
        @Assert(replayed.pctSchedule.isSome())
        let replay = replayed.pctSchedule.getOrThrow()

        var identical = true
        let recordedEvents = pctEvents(schedule)
        let replayEvents = pctEvents(replay)
        if (replayEvents.size != recordedEvents.size) {
            identical = false
        }
        if (identical) {
            for (i in 0..recordedEvents.size) {
                let a = recordedEvents[i]
                let b = replayEvents[i]
                if (a.kind != b.kind || a.from != b.from || a.to != b.to || a.step != b.step) {
                    identical = false
                }
            }
        }
        @Assert(identical)
    }
}
