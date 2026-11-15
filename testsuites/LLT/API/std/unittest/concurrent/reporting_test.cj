/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: helpers
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt -p helpers %compile_lib_opt --output p.%middle
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle %f %cmp_utest_opt %enableO2 -o %output
// EXEC-PIPE: %export cjHeapSize=4GB && %set_stdx_path %run %run_opt %output %run_utest_opt --no-color --show-all-output 2>&1 | compare %f
// ASSERT: scan Status: FAILED

// ASSERT: scan Consistency validation failed
// ASSERT: scan NOT serializable
// ASSERT: scan Ordering:
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan op_0
// ASSERT: scan ≠
// ASSERT: scan ✗

// ASSERT: scan operation checks

// ASSERT: scan Ordering:
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan Actor 2
// ASSERT: scan op_0
// ASSERT: scan ≠
// ASSERT: scan ✗
// ASSERT: scan inconsistent

// ASSERT: scan Ordering: per-actor
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan op_0
// ASSERT: scan op_1
// ASSERT: scan -------
// ASSERT: scan ≠
// ASSERT: scan ✗

// ASSERT: scan === Example 2: double barrier ===
// ASSERT: scan NOT linearizable
// ASSERT: scan Ordering: per-actor + real-time
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan op_0
// ASSERT: scan op_1
// ASSERT: scan -------
// ASSERT: scan ≠
// ASSERT: scan ✗

// ASSERT: scan === Example 3: single barrier ===
// ASSERT: scan NOT linearizable
// ASSERT: scan Ordering: per-actor + real-time
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan op_0
// ASSERT: scan op_1
// ASSERT: scan -------
// ASSERT: scan ≠
// ASSERT: scan ✗

// ASSERT: scan === Example 1: complex partial order ===
// ASSERT: scan NOT linearizable
// ASSERT: scan Ordering: per-actor + real-time
// ASSERT: scan Actor 0
// ASSERT: scan Actor 1
// ASSERT: scan Actor 2
// ASSERT: scan op_0
// ASSERT: scan op_1
// ASSERT: scan op_2
// ASSERT: scan -------
// ASSERT: scan ≠
// ASSERT: scan ✗

// ASSERT: scan-not Executed operations:
// ASSERT: scan-not Sequentialization failure
// ASSERT: scan-not with randomSeed

import std.unittest.*
import std.unittest.testmacro.*
import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.sync.AtomicInt64
import std.collection.ArrayList

// Prints a failed scenario's full report: the per-iteration summary and
// every consistency verdict with its mismatch details.
func printScenarioReport(result: ScenarioResult): Unit {
    println(result.report())
    for (v in result.consistencyValidations) {
        println(v.report())
    }
}

@TestBuilder
func testVerifyFailure(): TestSuite {
    let counter = AtomicInt64(0)

    let scenario = scenario("atomic_counter_test")
        .iterations(10)
        .actor { => counter.fetchAdd(1) }
        .actor { => counter.fetchAdd(-1) }
        .verify { => counter.load() == 1 }
        .build()

    TestSuite
        .builder("verify_failure_suite")
        .add(UnitTestCase.create("test_atomic_counter") {
            =>
            let result = scenario.run()
            if (!result.passed) {
                printScenarioReport(result)
            }
            @Assert(!result.passed)
        })
        .build()
}

var counter = 0

@TestBuilder
func testConsistencyFailure(): TestSuite {
    let scenario = scenario("counter_data_race")
        .reset { => counter = 0 }
        .consistencyModel(Serializability)
        .actor({ => counter += 1; counter })
        .actor({ => counter -= 1; counter })
        .iterations(1000)
        .build()

    TestSuite
        .builder("consistency_failure_suite")
        .add(UnitTestCase.create("counter_data_race") {
            =>
            let result = scenario.run()
            if (!result.passed) {
                printScenarioReport(result)
            }
            @Assert(!result.passed)
        })
        .build()
}

class AlwaysInconsistent <: Equatable<AlwaysInconsistent> & ToString {
    public operator func == (other: AlwaysInconsistent): Bool { false }
    public func toString(): String { "inconsistent" }
}

@TestBuilder
func testMultipleMismatches(): TestSuite {
    let scenario = scenario("multi_mismatch_test")
        .reset { => counter = 0 }
        .consistencyModel(Serializability)
        .actor({ => counter += 1; AlwaysInconsistent() })
        .actor({ => counter += 2; AlwaysInconsistent() })
        .actor({ => counter += 3; AlwaysInconsistent() })
        .iterations(1)
        .build()

    TestSuite
        .builder("multiple_mismatches_suite")
        .add(UnitTestCase.create("multi_mismatch_test") {
            =>
            let result = scenario.run()
            if (!result.passed) {
                printScenarioReport(result)
            }
            @Assert(!result.passed)
        })
        .build()
}

@TestBuilder
func testSequentialConsistencyBarriers(): TestSuite {
    let ops0: Array<Operation<Unit>> = [
        operation("op_0") { => counter += 1; AlwaysInconsistent() },
        operation("op_1") { => counter += 2; AlwaysInconsistent() }
    ]
    let ops1: Array<Operation<Unit>> = [
        operation("op_0") { => counter += 3; AlwaysInconsistent() }
    ]

    let scenario = scenario("sc_barriers_test")
        .reset { => counter = 0 }
        .consistencyModel(SequentialConsistency)
        .actorWithOps(ops0)
        .actorWithOps(ops1)
        .iterations(1)
        .build()

    TestSuite
        .builder("sc_barriers_suite")
        .add(UnitTestCase.create("sc_barriers_test") {
            =>
            let result = scenario.run()
            if (!result.passed) {
                printScenarioReport(result)
            }
            @Assert(!result.passed)
        })
        .build()
}

class DummyState {}

func testExample2DoubleBarrier(): Unit {
    let actor0Ops = ArrayList<OperationInvocation>()
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 1 }),
        invocationVC: Some([0, 0]), responseVC: Some([1, 0])
    ))
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 5 }),
        invocationVC: Some([2, 3]), responseVC: Some([3, 3])
    ))

    let actor1Ops = ArrayList<OperationInvocation>()
    actor1Ops.add(newOperationInvocation(
        actorId: 1, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 3 }),
        invocationVC: Some([0, 0]), responseVC: Some([0, 1])
    ))
    actor1Ops.add(newOperationInvocation(
        actorId: 1, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 4 }),
        invocationVC: Some([1, 1]), responseVC: Some([2, 2])
    ))

    let specExec = { _: Any, inv: OperationInvocation =>
        match (inv.actorId * 10 + inv.operationIndex) {
            case 0 => execResultOf({ => 1 })
            case 1 => execResultOf({ => 6 })
            case 10 => execResultOf({ => 3 })
            case 11 => execResultOf({ => 4 })
            case _ => execResultOf({ => 0 })
        }
    }

    let result = validateManualHistory(
        Linearizability,
        [actor0Ops, actor1Ops],
        { => DummyState() },
        specExec
    )

    println(result.report())
    match (result.getMismatchDetails()) {
        case Some(details) => println(details)
        case None => println("No mismatch details")
    }
}

func testExample3SingleBarrier(): Unit {
    let actor0Ops = ArrayList<OperationInvocation>()
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 1 }),
        invocationVC: Some([0, 0]), responseVC: Some([1, 0])
    ))
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 5 }),
        invocationVC: Some([1, 3]), responseVC: Some([2, 3])
    ))

    let actor1Ops = ArrayList<OperationInvocation>()
    actor1Ops.add(newOperationInvocation(
        actorId: 1, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 3 }),
        invocationVC: Some([0, 0]), responseVC: Some([0, 1])
    ))
    actor1Ops.add(newOperationInvocation(
        actorId: 1, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 4 }),
        invocationVC: Some([0, 1]), responseVC: Some([1, 2])
    ))

    let specExec = { _: Any, inv: OperationInvocation =>
        match (inv.actorId * 10 + inv.operationIndex) {
            case 0 => execResultOf({ => 1 })
            case 1 => execResultOf({ => 6 })
            case 10 => execResultOf({ => 3 })
            case 11 => execResultOf({ => 4 })
            case _ => execResultOf({ => 0 })
        }
    }

    let result = validateManualHistory(
        Linearizability,
        [actor0Ops, actor1Ops],
        { => DummyState() },
        specExec
    )

    println(result.report())
    match (result.getMismatchDetails()) {
        case Some(details) => println(details)
        case None => println("No mismatch details")
    }
}

func testExample1Complex(): Unit {
    let actor0Ops = ArrayList<OperationInvocation>()
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 1 }),
        invocationVC: Some([0, 0, 0]), responseVC: Some([1, 0, 0])
    ))
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 5 }),
        invocationVC: Some([1, 0, 0]), responseVC: Some([2, 0, 0])
    ))
    actor0Ops.add(newOperationInvocation(
        actorId: 0, operationIndex: 2, operationName: "op_2",
        result: execResultOf({ => 5 }),
        invocationVC: Some([3, 3, 1]), responseVC: Some([4, 3, 1])
    ))

    let actor1Ops = ArrayList<OperationInvocation>()
    actor1Ops.add(newOperationInvocation(
        actorId: 1, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 4 }),
        invocationVC: Some([0, 0, 0]), responseVC: Some([0, 1, 0])
    ))
    actor1Ops.add(newOperationInvocation(
        actorId: 1, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 2 }),
        invocationVC: Some([0, 1, 0]), responseVC: Some([0, 3, 0])
    ))

    let actor2Ops = ArrayList<OperationInvocation>()
    actor2Ops.add(newOperationInvocation(
        actorId: 2, operationIndex: 0, operationName: "op_0",
        result: execResultOf({ => 6 }),
        invocationVC: Some([3, 0, 0]), responseVC: Some([3, 1, 1])
    ))
    actor2Ops.add(newOperationInvocation(
        actorId: 2, operationIndex: 1, operationName: "op_1",
        result: execResultOf({ => 7 }),
        invocationVC: Some([3, 1, 1]), responseVC: Some([3, 2, 2])
    ))

    let specExec = { _: Any, inv: OperationInvocation =>
        match (inv.actorId * 10 + inv.operationIndex) {
            case 0 => execResultOf({ => 1 })
            case 1 => execResultOf({ => 5 })
            case 2 => execResultOf({ => 5 })
            case 10 => execResultOf({ => 4 })
            case 11 => execResultOf({ => 2 })
            case 20 => execResultOf({ => 6 })
            case 21 => execResultOf({ => 6 })
            case _ => execResultOf({ => 0 })
        }
    }

    let result = validateManualHistory(
        Linearizability,
        [actor0Ops, actor1Ops, actor2Ops],
        { => DummyState() },
        specExec
    )

    println(result.report())
    match (result.getMismatchDetails()) {
        case Some(details) => println(details)
        case None => println("No mismatch details")
    }
}

@TestBuilder
func testManualHistoryExamples(): TestSuite {
    TestSuite
        .builder("manual_history_suite")
        .add(UnitTestCase.create("example_2_double_barrier") {
            =>
            println("=== Example 2: double barrier ===")
            testExample2DoubleBarrier()
        })
        .add(UnitTestCase.create("example_3_single_barrier") {
            =>
            println("=== Example 3: single barrier ===")
            testExample3SingleBarrier()
        })
        .add(UnitTestCase.create("example_1_complex") {
            =>
            println("=== Example 1: complex partial order ===")
            testExample1Complex()
        })
        .build()
}
