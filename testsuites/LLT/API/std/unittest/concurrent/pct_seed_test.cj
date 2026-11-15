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

// Seed-first schedule reproduction: every scheduling draw (priority
// permutation, PCP fire/victim, actor registration ranks) comes from the
// coordinator's Random(seed), so for deterministic programs the same seed
// re-derives the identical event stream — no recorded schedule needed.

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctSeedTests {
    static func eventsIdentical(a: PCTSchedule, b: PCTSchedule): Bool {
        let aEvents = pctEvents(a)
        let bEvents = pctEvents(b)
        if (aEvents.size != bEvents.size) {
            return false
        }
        for (i in 0..aEvents.size) {
            let ea = aEvents[i]
            let eb = bEvents[i]
            if (ea.kind != eb.kind || ea.from != eb.from ||
                ea.to != eb.to || ea.step != eb.step) {
                return false
            }
        }
        true
    }

    /// A randomly seeded run's schedule is re-derived bit-for-bit by
    /// re-running the same scenario with `.pctSeed(<recorded seed>)`: same
    /// event kinds, from/to actors and steps (the seed-path sibling of the
    /// replay test — replay re-applies recorded events, the seed re-derives
    /// them).
    @TestCase
    func test_seed_rerun_reproduces_schedule(): Unit {
        println("Testing PCT seed re-run reproduction...")

        let counter = AtomicInt64(0)
        let body = { =>
            let _ = counter.fetchAdd(1)
            let _ = counter.fetchAdd(10)
        }

        let recorded = scenario("pct_seed_source")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(1)
            .actor(body)
            .actor(body)
            .verify { => counter.load() == 22 }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let schedule = recorded.pctSchedule.getOrThrow()
        @Assert(!pctIsDiverged(schedule))
        println("Recorded (seed=${pctScheduleSeed(schedule)}): ${schedule.report()}")

        counter.store(0)
        let rerun = scenario("pct_seed_rerun")
            .mode(PCT)
            .priorityChangePoints(2)
            .pctSeed(pctScheduleSeed(schedule))
            .actor(body)
            .actor(body)
            .verify { => counter.load() == 22 }
            .build()
            .run()

        @Assert(rerun.passed)
        @Assert(rerun.pctSchedule.isSome())
        let rerunSchedule = rerun.pctSchedule.getOrThrow()
        @Assert(!pctIsDiverged(rerunSchedule))
        @Assert(pctScheduleSeed(rerunSchedule) == pctScheduleSeed(schedule))
        @Assert(eventsIdentical(schedule, rerunSchedule))
        println("Re-derived ${pctEvents(rerunSchedule).size} events from seed=${pctScheduleSeed(schedule)}")
    }

    /// A failing iteration prints the seed hint (the scenario path's
    /// reproduction mechanism) — exercised here end-to-end through a
    /// deliberately failing verify block; the run itself reports failure.
    @TestCase
    func test_failure_reports_seed(): Unit {
        println("Testing PCT failure seed reporting...")

        let result = scenario("pct_seed_failing_verify")
            .mode(PCT)
            .iterations(1)
            .actor { => () }
            .verify { => false }
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.pctSchedule.isSome())
        let schedule = result.pctSchedule.getOrThrow()
        // The hint line carries the seed; the schedule records it too.
        println("Failing iteration seed=${pctScheduleSeed(schedule)} (hint printed above)")
    }
}
