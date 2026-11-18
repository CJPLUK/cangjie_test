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
// ASSERT: scan PASSED: 2

// The per-schedule switch bound (ScenarioBuilder.switchBound): a cap on
// VOLUNTARY token switches — op-boundary/grid preemptions away from a
// willing holder. It complements priorityChangePoints (which bounds
// priority-change fires; one fired change point can cascade into
// several preemptions). Forced transfers (actor registration parks,
// blocking sync waits) never count, so bounded schedules still complete and
// verify, and the recorded event stream carries at most `k` Switch
// events — a deterministic, seed-independent property.

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctSwitchBoundTests {
    static func switchCount(s: PCTSchedule): Int64 {
        var n: Int64 = 0
        for (ev in pctEvents(s)) {
            // The initial token grant logs a Switch event with from ==
            // -1; voluntary preemptions are the ones away from a holder.
            if (ev.kind == Switch && ev.from >= 0) {
                n += 1
            }
        }
        return n
    }

    /// Bound 0: fully serial schedules — every op-boundary and grid
    /// decision keeps the holder; the token moves only through forced
    /// handoffs (the actor registration parks, the blocking waits). The
    /// scenario completes, verifies, and records zero Switch events.
    @TestCase
    func test_bound_zero_records_no_switches(): Unit {
        println("Testing PCT switch bound 0...")

        let counter = AtomicInt64(0)
        let result = scenario("pct_switch_zero")
            .mode(PCT)
            .pctSeed(7u64)
            .switchBound(0)
            .actor { =>
                let _ = counter.fetchAdd(1)
                let _ = counter.fetchAdd(10)
            }
            .actor { => let _ = counter.fetchAdd(100) }
            .verify { => counter.load() == 111 }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        @Assert(!pctIsDiverged(schedule))
        println("Bound 0: ${switchCount(schedule)} switches, ${pctEvents(schedule).size} events")
        @Assert(switchCount(schedule) == 0)
    }

    /// Bound 1 across several seeds: scenarios complete and verify, and
    /// no schedule ever records more than one voluntary switch — the
    /// cap holds regardless of what the seeded RNG stream draws (PCPs
    /// may still fire and reorder priorities; the preemptions they
    /// would cause are simply suppressed once the budget is spent).
    @TestCase
    func test_bound_one_caps_switches(): Unit {
        println("Testing PCT switch bound 1 across seeds...")

        for (seed in [1u64, 2u64, 3u64, 42u64]) {
            let counter = AtomicInt64(0)
            let result = scenario("pct_switch_one_${seed}")
                .mode(PCT)
                .pctSeed(seed)
                .switchBound(1)
                .actor { =>
                    let _ = counter.fetchAdd(1)
                    let _ = counter.fetchAdd(10)
                }
                .actor { => let _ = counter.fetchAdd(100) }
                .verify { => counter.load() == 111 }
                .build()
                .run()

            @Assert(result.passed)
            @Assert(result.pctSchedule.isSome())
            let schedule = result.pctSchedule.getOrThrow()
            @Assert(!pctIsDiverged(schedule))
            let switches = switchCount(schedule)
            println("Seed ${seed}: ${switches} switches, ${pctEvents(schedule).size} events")
            @Assert(switches <= 1)
        }
    }
}
