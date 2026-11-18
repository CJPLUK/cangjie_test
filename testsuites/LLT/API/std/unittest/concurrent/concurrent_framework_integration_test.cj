/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -o %n.%suffix %f %cmp_utest_opt %enableO2
// EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_utest_opt --no-color 2>&1 | compare %f

// Scenario-layer behavior through the plain framework entry (UnitTestCase
// bodies calling ConcurrentScenario.run() directly — the ConcurrentTestCase
// adapter has been removed with the std.unittest integration).
// ASSERT: scan [ PASSED ] CASE: test_atomic_counter
// ASSERT: scan [ PASSED ] CASE: test_concurrent_lifecycle
// ASSERT: scan --beforeAll--
// ASSERT: scan --beforeEach: test_concurrent_lifecycle--
// ASSERT: scan --afterEach--
// ASSERT: scan --afterAll--
// ASSERT: scan [ PASSED ] CASE: passing_test_1
// ASSERT: scan [ PASSED ] CASE: reset_test
// ASSERT: scan [ PASSED ] CASE: failing_scenario_check
// ASSERT: scan [ PASSED ] CASE: data_race
// ASSERT: scan Ordering: per-actor + real-time (------- = barrier, ... = bridge)
// ASSERT: scan Actor 0     Actor 1
// ASSERT: scan op_0: 1 ✓   op_0: -1 ≠ 0 ✗
// ASSERT: scan PASSED: 6
// ASSERT: scan TOTAL: 6

import std.unittest.*
import std.unittest.testmacro.*
import stdx.unittest.concurrent.*
import std.sync.AtomicInt64

@TestBuilder
func testDirectRun(): TestSuite {
    let counter = AtomicInt64(0)

    let scenario = scenario("atomic_counter_test")
        .iterations(10)
        .actor { => counter.fetchAdd(1) }
        .actor { => counter.fetchAdd(-1) }
        .verify { => counter.load() == 0 }
        .build()

    TestSuite
        .builder("direct_run_suite")
        .add(UnitTestCase.create("test_atomic_counter") {
            =>
            let result = scenario.run()
            @Assert(result.passed)
        })
        .build()
}

@TestBuilder
func testWithLifecycle(): TestSuite {
    // The framework's suite lifecycle hooks fire around ordinary cases; the
    // case body runs a scenario directly.
    let counter = AtomicInt64(0)

    let scenario = scenario("lifecycle_test")
        .iterations(5)
        .actor { => counter.fetchAdd(1) }
        .verify { => counter.load() >= 0 }
        .build()

    TestSuite
        .builder("concurrent_suite")
        .beforeAll { => println("--beforeAll--") }
        .beforeEach { name => println("--beforeEach: ${name}--") }
        .afterEach { => println("--afterEach--") }
        .afterAll { => println("--afterAll--") }
        .add(UnitTestCase.create("test_concurrent_lifecycle") {
            =>
            let result = scenario.run()
            @Assert(result.passed)
        })
        .build()
}

@TestBuilder
func testMultipleConcurrentTests(): TestSuite {
    // A failing scenario is an assertion finding, not a framework failure:
    // each case asserts its scenario's verdict.
    let passingCounter = AtomicInt64(0)
    let passingScenario = scenario("passing_test")
        .iterations(5)
        .actor { => passingCounter.fetchAdd(1) }
        .verify { => passingCounter.load() >= 0 }
        .build()

    let failingCounter = AtomicInt64(0)
    let failingScenario = scenario("failing_test")
        .iterations(1)
        .actor { => failingCounter.fetchAdd(1) }
        .verify { => false }
        .build()

    let resetCounter = AtomicInt64(0)
    let resetScenario = scenario("reset_test")
        .iterations(1)
        .actor { => resetCounter.store(0) }
        .verify { => resetCounter.load() == 0 }
        .build()

    TestSuite
        .builder("mixed_concurrent_suite")
        .add(UnitTestCase.create("passing_test_1") {
            =>
            @Assert(passingScenario.run().passed)
        })
        .add(UnitTestCase.create("failing_scenario_check") {
            =>
            @Assert(!failingScenario.run().passed)
        })
        .add(UnitTestCase.create("reset_test") {
            =>
            @Assert(resetScenario.run().passed)
        })
        .build()
}

var counter = 0

@TestBuilder
func testDataRaceReport(): TestSuite {
    let scenario = scenario("data_race_not_linearizable")
        .consistencyModel(Linearizability)
        .reset { => counter = 0 }
        .actor({ => counter += 1; counter })
        .actor({ => counter -= 1; counter })
        .iterations(1000)
        .build()

    TestSuite
        .builder("data_race_suite")
        .add(UnitTestCase.create("data_race") {
            =>
            let result = scenario.run()
            println(result.report())
            @Assert(!result.passed)
        })
        .build()
}
