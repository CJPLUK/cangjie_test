/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: verifies that an iteration whose setup throws (the user state
// factory, the reset block) produces a failed iteration result instead of
// escaping the dispatch: every dispatched iteration — sequential or
// parallel — yields exactly one result, so the parallel drain always
// terminates and run() returns; the failing iteration carries the thrown
// error in its actor failure details, so the report surfaces it. A setup
// failure on the sequential iteration 0 fails the run the same way
// (early exit).
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -o %output %f %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 3

// ASSERT: scan state-boom
// ASSERT: scan reset-boom
// ASSERT: scan state-boom-first
// ASSERT: scan iteration_setup

import stdx.unittest.concurrent.*
import std.sync.AtomicInt64

@Test
class ParallelFailureTests {
    /// A typed scenario (withState, so iterations run in parallel by
    /// default) whose state factory throws on its second call: iteration 0
    /// passes, a parallel iteration fails with the factory error, run()
    /// returns with passed == false and the report names the error. The
    /// test completing at all is part of the assertion — a dispatch that
    /// loses a result leaves the drain waiting forever (a CI timeout).
    @TestCase
    func test_parallel_state_factory_failure(): Unit {
        println("Testing parallel iteration state factory failure...")

        let factoryCalls = AtomicInt64(0)
        let result = scenario("parallel_state_factory_boom")
            .withState { =>
                if (factoryCalls.fetchAdd(1) == 1) {
                    throw IllegalArgumentException("state-boom")
                }
                AtomicInt64(0)
            }
            .consistencyModel(NoValidation)
            .actor { c => c.fetchAdd(1) }
            .actor { c => c.fetchSub(1) }
            .iterations(3)
            .build()
            .run()

        @Assert(!result.passed)
        // Iteration 0 always runs; the failing parallel iteration is
        // dispatched and reported before the early exit.
        @Assert(result.iterationsExecuted >= 2)
        let reportText = result.report().toString()
        println(reportText)
        @Assert(reportText.contains("state-boom"))
        @Assert(reportText.contains("iteration_setup"))
    }

    /// A capture-based scenario with an explicit parallel-iteration
    /// override whose reset block throws on its second call: the same
    /// contract — the parallel iteration fails with the reset error and
    /// run() returns instead of hanging the drain.
    @TestCase
    func test_parallel_reset_failure(): Unit {
        println("Testing parallel iteration reset failure...")

        let resets = AtomicInt64(0)
        let counter = AtomicInt64(0)
        let result = scenario("parallel_reset_boom")
            .consistencyModel(NoValidation)
            .parallelIterations(true)
            .reset { =>
                if (resets.fetchAdd(1) == 1) {
                    throw IllegalArgumentException("reset-boom")
                }
                counter.store(0)
            }
            .actor { => counter.fetchAdd(1) }
            .iterations(3)
            .build()
            .run()

        @Assert(!result.passed)
        @Assert(result.iterationsExecuted >= 2)
        let reportText = result.report().toString()
        println(reportText)
        @Assert(reportText.contains("reset-boom"))
        @Assert(reportText.contains("iteration_setup"))
    }

    /// A state factory that throws on its very first call: the sequential
    /// iteration 0 is failed the same way — run() returns (no exception
    /// unwinds it), the report carries the error, and the early exit stops
    /// every further iteration.
    @TestCase
    func test_sequential_first_iteration_factory_failure(): Unit {
        println("Testing first-iteration state factory failure...")

        let factoryCalls = AtomicInt64(0)
        let result = scenario("first_iteration_factory_boom")
            .withState { =>
                if (factoryCalls.fetchAdd(1) == 0) {
                    throw IllegalArgumentException("state-boom-first")
                }
                AtomicInt64(0)
            }
            .consistencyModel(NoValidation)
            .actor { c => c.fetchAdd(1) }
            .iterations(3)
            .build()
            .run()

        @Assert(!result.passed)
        // Early exit on iteration 0: nothing else ran.
        @Assert(result.iterationsExecuted == 1)
        let reportText = result.report().toString()
        println(reportText)
        @Assert(reportText.contains("state-boom-first"))
        @Assert(reportText.contains("iteration_setup"))
    }
}
