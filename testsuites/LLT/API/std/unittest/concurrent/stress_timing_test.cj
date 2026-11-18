/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// NOTE: verifies that stress-mode actor results carry really-measured
// execution windows (opened at the start signal, closed at op-loop
// completion) and the actors' configured names: every per-actor duration
// of every executed iteration is positive, so the iteration-0 average
// duration that calibrates the backoff sigma reflects the actual workload.
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 2

// ASSERT: scan busy_worker_a
// ASSERT: scan busy_worker_b
// ASSERT: scan actor durations

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.AtomicInt64

// A counted busy workload: long enough that a real execution window sits
// far above the clock's resolution.
func busyWork(spins: Int64): Int64 {
    var acc: Int64 = 0
    var i: Int64 = 0
    while (i < spins) {
        acc += i
        i += 1
    }
    acc
}

@Test
class StressTimingTests {
    /// Named actors doing measurable work: every recorded per-actor
    /// duration of the calibration iteration is positive, and the
    /// configured actor names surface in the actor results.
    @TestCase
    func test_stress_actor_timings_are_measured(): Unit {
        println("Testing stress actor timings...")

        let result = scenario("stress_timings_measured")
            .actor("busy_worker_a") { => busyWork(2_000_000) }
            .actor("busy_worker_b") { => busyWork(2_000_000) }
            .iterations(3)
            .build()
            .run()

        @Assert(result.passed)
        println(result.report())

        let durations = actorDurationsNanos(result)
        @Assert(durations.size == 2)
        for (d in durations) {
            @Assert(d > 0)
        }
        let names = actorNames(result)
        @Assert(names[0] == "busy_worker_a")
        @Assert(names[1] == "busy_worker_b")
        println("actor names: ${names[0]}, ${names[1]}")
        println("iteration-0 actor durations (ns): ${durations[0]}, ${durations[1]}")
    }

    /// Real timings hold for every executed iteration — the sequential
    /// iteration 0 and the parallel iterations alike (withState runs
    /// iterations 1..N-1 in parallel by default).
    @TestCase
    func test_stress_timings_every_iteration(): Unit {
        println("Testing stress timings across all iterations...")

        let result = scenario("stress_timings_all_iterations")
            .withState { => AtomicInt64(0) }
            .consistencyModel(NoValidation)
            .actor { c => busyWork(1_000_000) + c.fetchAdd(1) }
            .iterations(5)
            .build()
            .run()

        @Assert(result.passed)
        @Assert(result.iterationsExecuted == 5)
        for (iter in 0..result.iterationsExecuted) {
            let durations = actorDurationsNanos(result, iteration: iter)
            @Assert(durations.size == 1)
            for (d in durations) {
                @Assert(d > 0)
            }
        }
        println("all ${result.iterationsExecuted} iterations recorded positive actor durations")
    }
}
