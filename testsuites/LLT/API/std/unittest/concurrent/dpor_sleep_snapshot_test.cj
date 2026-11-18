/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt --experimental --cj-pct %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 2

import std.convert.Parsable
import std.sync.*
import stdx.unittest.concurrent.*

/**
 * The stateless-contract regression shape of
 * temp/dpor-study/LIVELOCK-BUG-REPORT.md: every sync key lives in the
 * scenario state, which is rebuilt FRESH for each schedule by the
 * scenario runner's state factory.
 */
class DporSleepKeyState {
    public let counter: AtomicInt64 = AtomicInt64(0)
    public let tag: AtomicInt64 = AtomicInt64(0)
}

/** A CAS-retry increment (the bug report's actor operation). */
func dporSleepCasInc(a: AtomicInt64): Unit {
    var done = false
    while (!done) {
        let v = a.load()
        done = a.compareAndSwap(v, v + 1)
    }
}

/** Extract a `field=<Int64>` token from a stats line (-1 when absent). */
func dporSleepStatField(stats: String, field: String): Int64 {
    let want = "${field}="
    for (tok in stats.split(" ")) {
        if (tok.startsWith(want)) {
            let parts = tok.split("=")
            if (parts.size >= 2) {
                return Int64.parse(parts[1])
            }
        }
    }
    return -1
}

@Test
class DporSleepSnapshotTests {
    /// The POP driver under fresh state per schedule (the stateless
    /// integration contract), at a budget the pre-POP livelock
    /// pathology could never reach: the driver must keep completing
    /// schedules through the whole budget (the per-schedule replay of
    /// the sleep-set characterization carries no cross-schedule state
    /// that could grow with the schedule count), and every schedule's
    /// pinned prefix must replay exactly — `diverged` stays 0 (a
    /// divergence drops branches, so it is the regression guard).
    /// NoValidation mirrors the raw-driver character of this stress:
    /// boundedness of the exploration itself, no per-schedule verdicts.
    @TestCase
    func test_dpor_sleep_snapshot_bounded(): Unit {
        println("Testing that the POP driver stays bounded under fresh state...")

        let result = scenario("dpor_sleep_snapshot_bounded")
            .mode(DPOR)
            .iterations(20000)
            .consistencyModel(NoValidation)
            .withState { => DporSleepKeyState() }
            .actorWithOps([
                operation<Int64, DporSleepKeyState>("inc1") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("tag") { s =>
                    let _ = s.tag.fetchAdd(1)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc2") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc3") { s =>
                    dporSleepCasInc(s.counter)
                    0
                }
            ])
            .actorWithOps([
                operation<Int64, DporSleepKeyState>("inc1") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("tag") { s =>
                    let _ = s.tag.fetchAdd(1)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc2") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc3") { s =>
                    dporSleepCasInc(s.counter)
                    0
                }
            ])
            .actorWithOps([
                operation<Int64, DporSleepKeyState>("inc1") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("tag") { s =>
                    let _ = s.tag.fetchAdd(1)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc2") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc3") { s =>
                    dporSleepCasInc(s.counter)
                    0
                }
            ])
            .build()
            .run()

        @Assert(result.passed)
        let r = result.dporReport.getOrThrow()
        @Assert(r.schedulesExplored == 20000)

        // The boundedness diagnostic: the budget is fully consumed (no
        // cross-schedule state growth can stall the driver), and the
        // pinned-prefix replay contract holds on every schedule.
        let schedules = dporSleepStatField(r.stats, "schedules")
        @Assert(schedules == 20000)
        let diverged = dporSleepStatField(r.stats, "diverged")
        @Assert(diverged == 0)
    }

    /// The stdx scenario-level integration (the bug report's entry
    /// point): `withState` builds fresh state per schedule inside the
    /// driver's beforeSchedule hook. The exploration must verify every
    /// schedule and stay bounded there too.
    @TestCase
    func test_dpor_scenario_fresh_state_bounded(): Unit {
        println("Testing DPOR scenario exploration with fresh state per schedule...")

        let result = scenario("dpor_fresh_state_bounded")
            .mode(DPOR)
            .iterations(3000)
            .withState { => DporSleepKeyState() }
            .actorWithOps([
                operation<Int64, DporSleepKeyState>("inc1") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("tag") { s =>
                    s.tag.fetchAdd(1)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc2") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc3") { s =>
                    dporSleepCasInc(s.counter)
                    0
                }
            ])
            .actorWithOps([
                operation<Int64, DporSleepKeyState>("inc1") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("tag") { s =>
                    s.tag.fetchAdd(1)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc2") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc3") { s =>
                    dporSleepCasInc(s.counter)
                    0
                }
            ])
            .actorWithOps([
                operation<Int64, DporSleepKeyState>("inc1") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("tag") { s =>
                    s.tag.fetchAdd(1)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc2") { s =>
                    dporSleepCasInc(s.counter)
                    0
                },
                operation<Int64, DporSleepKeyState>("inc3") { s =>
                    dporSleepCasInc(s.counter)
                    0
                }
            ])
            .verify { s => s.counter.load() == 9 && s.tag.load() == 3 }
            .build()
            .run()

        @Assert(result.passed)
        let dpor = result.dporReport
        @Assert(dpor.isSome())
        if (let Some(d) <- dpor) {
            @Assert(d.schedulesExplored == 3000)
            @Assert(!d.deadlocked)
            let schedules = dporSleepStatField(d.stats, "schedules")
            @Assert(schedules == 3000)
            let diverged = dporSleepStatField(d.stats, "diverged")
            @Assert(diverged == 0)
        }
    }
}
