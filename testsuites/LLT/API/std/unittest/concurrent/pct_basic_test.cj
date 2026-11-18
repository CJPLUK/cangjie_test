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
class PctBasicTests {
    @TestCase
    func test_pct_atomic_counter(): Unit {
        println("Testing PCT mode on a linearizable atomic counter...")

        let counter = AtomicInt64(0)

        let result = scenario("pct_atomic_counter")
            .mode(PCT)
            .priorityChangePoints(2)
            .iterations(5)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(result.passed)

        // A PCT-mode run must record a schedule for every iteration.
        if (let Some(schedule) <- result.pctSchedule) {
            @Assert(pctEvents(schedule).size > 0)
            @Assert(pctSchedulePollCount(schedule) > 0)
            @Assert(!pctIsDeadlocked(schedule))
            @Assert(!pctIsDiverged(schedule))
            println("Schedule: ${schedule.report()}")
        } else {
            @Assert(false)
        }
    }

    @TestCase
    func test_pct_typed_state_linearizability(): Unit {
        println("Testing PCT mode with typed state and linearizability validation...")

        let result = scenario("pct_typed_state")
            .mode(PCT)
            .withState { => AtomicInt64(0) }
            .consistencyModel(Linearizability)
            .priorityChangePoints(2)
            .iterations(5)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchAdd(-1) }
            .build()
            .run()

        @Assert(result.passed)
        if (let Some(schedule) <- result.pctSchedule) {
            @Assert(!pctIsDiverged(schedule))
            @Assert(!pctIsDeadlocked(schedule))
        } else {
            @Assert(false)
        }
    }

    @TestCase
    func test_stress_mode_has_no_pct_schedule(): Unit {
        println("Testing that stress mode is unchanged (no PCT schedule recorded)...")

        let counter = AtomicInt64(0)

        let result = scenario("stress_unchanged")
            .iterations(3)
            .actor { => counter.fetchAdd(1) }
            .actor { => counter.fetchAdd(-1) }
            .verify { => counter.load() == 0 }
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.pctSchedule.isNone())
    }
}
