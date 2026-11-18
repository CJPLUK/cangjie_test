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
// ASSERT: scan PASSED: 1

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.*

@Test
class PctReplayTests {
    /// Record a schedule with one PCT run, replay it, and check the replay
    /// reproduces the same decision sequence without divergence.
    @TestCase
    func test_pct_record_and_replay(): Unit {
        println("Testing PCT schedule record + replay...")

        let counter = AtomicInt64(0)

        // Recording run.
        let recorded = scenario("pct_replay_source")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(1)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(recorded.passed)
        @Assert(recorded.pctSchedule.isSome())
        let schedule = recorded.pctSchedule.getOrThrow()
        @Assert(pctEvents(schedule).size > 0)
        println("Recorded: ${schedule.report()}")

        // Replay run: same scenario (fresh state), replayed schedule.
        let replayCounter = AtomicInt64(0)
        let replayed = scenario("pct_replay_replay")
            .mode(PCT)
            .priorityChangePoints(pctSchedulePcpBudget(schedule))
            .replaySchedule(schedule)
            .actor { => replayCounter.fetchAdd(1) }
            .actor { => replayCounter.fetchAdd(-1) }
            .verify { => replayCounter.load() == 0 }
            .build()
            .run()

        @Assert(replayed.passed)

        // The replay re-recorded its own schedule; a faithful replay must not
        // diverge and must produce the same decision sequence.
        @Assert(replayed.pctSchedule.isSome())
        let replaySchedule = replayed.pctSchedule.getOrThrow()
        @Assert(!pctIsDiverged(replaySchedule))
        @Assert(!pctIsDeadlocked(replaySchedule))
        println("Replayed: ${replaySchedule.report()}")

        let recordedEvents = pctEvents(schedule)
        let replayedEvents = pctEvents(replaySchedule)
        @Assert(replayedEvents.size == recordedEvents.size)
        for (i in 0..recordedEvents.size) {
            let expected = recordedEvents[i]
            let actual = replayedEvents[i]
            @Assert(expected.kind == actual.kind)
            @Assert(expected.from == actual.from)
            @Assert(expected.to == actual.to)
        }
    }
}
