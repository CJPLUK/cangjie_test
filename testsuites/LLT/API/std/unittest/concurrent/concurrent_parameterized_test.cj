/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -o %n.%suffix %f %cmp_utest_opt %enableO2
// EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_utest_opt --no-color 2>&1 | compare %f

// Scenario factories driven by ordinary input loops. (The former
// DataStrategy-driven parameterized concurrent cases went through the
// removed std.unittest adapter; the scenario layer itself has no
// DataStrategy integration.)
// ASSERT: scan [ PASSED ] CASE: param_pass_builder
// ASSERT: scan [ PASSED ] CASE: param_pass_create
// ASSERT: scan [ PASSED ] CASE: param_fail
// ASSERT: scan PASSED: 3
// ASSERT: scan TOTAL: 3

import std.unittest.*
import std.unittest.testmacro.*
import stdx.unittest.concurrent.*
import std.sync.AtomicInt64

// Inputs drive the scenario factories: every value builds a fresh scenario
// (here: with that many iterations), all of them pass.
func makePassingScenario(n: Int64): ConcurrentScenario<Unit> {
    let counter = AtomicInt64(0)
    scenario("param_pass_builder")
        .iterations(n)
        .actor { => counter.fetchAdd(1) }
        .actor { => counter.fetchAdd(-1) }
        .verify { => counter.load() == 0 }
        .build()
}

@TestBuilder
func testParameterizedConcurrent(): TestSuite {
    let builder = TestSuite.builder("param_concurrent_suite")

    // Builder-factory style: build per input, run, assert.
    builder.add(UnitTestCase.create("param_pass_builder") {
        =>
        for (n in [1, 5, 25]) {
            @Assert(makePassingScenario(n).run().passed)
        }
    })

    // Built-scenario style: the same factory, run per input.
    builder.add(UnitTestCase.create("param_pass_create") {
        =>
        for (n in [10, 50]) {
            let counter = AtomicInt64(0)
            let scenario = scenario("param_pass_create")
                .iterations(n)
                .actor { => counter.fetchAdd(1) }
                .actor { => counter.fetchAdd(-1) }
                .verify { => counter.load() == 0 }
                .build()
            @Assert(scenario.run().passed)
        }
    })

    // Threshold scenarios: inputs 1 and 4 pass, 16 and 64 fail. The loop
    // asserts each input's verdict (first failure no longer stops the
    // remaining inputs — that was the removed adapter's step semantics).
    builder.add(UnitTestCase.create("param_fail") {
        =>
        for (threshold in [1, 4]) {
            let counter = AtomicInt64(0)
            let scenario = scenario("param_fail")
                .iterations(2)
                .actor { => counter.fetchAdd(1) }
                .verify { => threshold < 8 }
                .build()
            @Assert(scenario.run().passed)
        }
        for (threshold in [16, 64]) {
            let counter = AtomicInt64(0)
            let scenario = scenario("param_fail")
                .iterations(2)
                .actor { => counter.fetchAdd(1) }
                .verify { => threshold < 8 }
                .build()
            @Assert(!scenario.run().passed)
        }
    })

    builder.build()
}
