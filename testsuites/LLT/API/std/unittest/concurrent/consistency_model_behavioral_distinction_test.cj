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
// EXEC: %compiler %import-stdx-unittest-concurrent %cmp_opt p.%middle %f -o %output %cmp_utest_opt %enableO2
// RUN-EXEC-PIPE: %set_stdx_path %run %run_opt %output %run_args %run_utest_opt --no-color | compare %f
// ASSERT: scan PASSED: 5

// Behavioral distinction tests for consistency models.
//
// Data structures with software-level non-atomic semantics (store buffers,
// delayed propagation, stale reads) can produce outcomes that distinguish
// consistency models behaviorally, not just structurally.
//
// Two approaches to specification:
//
// A) Thread-dependent behavior (RegisterWithStoreBuffer): The shared object itself
//    serves as both implementation and specification. During concurrent execution,
//    reader threads see stale committedValue (different thread ID than writer).
//    During sequential validation (single thread), the writer's own read commits
//    the pending value, producing the correct result. No separate spec needed.
//
// B) Separate specification (LazyPropagateTwoFieldRegister): When the buggy object
//    produces stale reads even in sequential execution, `sequentialSpec()` provides
//    a CORRECT specification object. The validator re-executes on the correct spec
//    and compares with observed buggy outcomes.
//
// Four behavioral distinctions demonstrated:
//
// 1. SC accepts, Linearizability rejects — RegisterWithStoreBuffer (basic)
//    Writer buffers to pendingValue, readers see stale committedValue=0.
//    Under SC (no VC constraint): permutation read(0), write(1) matches
//    sequential re-execution (same thread commits on read). Under linearizability
//    (VC: write completed before read started): no valid linearization —
//    write must precede read, but read=0 after write=1 is invalid.
//    Probabilistic: relies on VC timing across 200 iterations.
//
// 2. SC accepts, Linearizability rejects — RegisterWithStoreBuffer (multi-op)
//    Writer with 4 operations (3 writes + 1 read), 2 separate reader actors.
//    Same store-buffer mechanism, more complex scenario with per-actor ordering.
//    Probabilistic: relies on VC timing across 200 iterations.
//
// 3. Serializability accepts, SC rejects — LazyPropagateTwoFieldRegister
//    Writes go to "pending" (never visible to reads), reads from "committed" (stale).
//    Outcome (getX=0, getY=0): achievable under serializability
//    (permutation: getY, getX, setX, setY on correct spec) but not under SC
//    (per-actor constraints: setX must precede getY, setY must precede getX — cycle).
//    Deterministic: uses sequentialSpec with SimpleTwoFieldRegister.
//
// 4. SC accepts, Linearizability rejects — manual history with specific VCs
//    Deterministic alternative to tests 1-2: manually constructed history with
//    VC timestamps guaranteeing write completed before read started.
//    Outcome (read=0 after write=1): achievable under SC but not linearizability.
package std.concurrent_test

import stdx.unittest.concurrent.*
import stdx.concurrent_test_util.*
import std.collection.ArrayList
import std.sync.AtomicInt64

class SimpleTwoFieldRegister {
    var x: Int64 = 0
    var y: Int64 = 0

    func setX(v: Int64): Int64 {
        x = v
        v
    }

    func setY(v: Int64): Int64 {
        y = v
        v
    }

    func getX(): Int64 {
        x
    }

    func getY(): Int64 {
        y
    }
}

class SimpleRegister {
    var value: Int64 = 0

    func write(v: Int64): Int64 {
        value = v
        v
    }

    func read(): Int64 {
        value
    }
}

// Should be SC but not linearizable due to delayed visibility of writes (stale reads).
// write should be called by the single writer actor/thread, but it allows multiple concurrent readers
class RegisterWithStoreBuffer {
    var committedValue: AtomicInt64 = AtomicInt64(0)
    var pendingValue: Int64 = 0
    var threadId: Int64 = -1

    func reset(): Unit {
        committedValue.store(0)
        pendingValue = 0
        threadId = -1
    }

    func write(v: Int64): Int64 {
        @Assert(threadId == -1 || threadId == Thread.currentThread.id)
        threadId = Thread.currentThread.id
        pendingValue = v
        v
    }

    func read(): Int64 {
        if (Thread.currentThread.id == threadId) {
            committedValue.store(pendingValue)
        }
        committedValue.load()
    }
}

@Test
class ConsistencyModelBehavioralDistinctionTests {
    var committedX: Int64 = 0
    var committedY: Int64 = 0
    var pendingX: Int64 = 0
    var pendingY: Int64 = 0
    var storeBufferReg = RegisterWithStoreBuffer()

    @TestCase
    func testStoreBufferRegister_scAccepts_linearizabilityRejects(): Unit {

        let scResult = scenario("storebuffer_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => storeBufferReg.reset() }
            .actor{ => storeBufferReg.write(1) }
            .actor{ => storeBufferReg.read() }
            .iterations(200)
            .build()
            .run()

        let linResult = scenario("storebuffer_lin")
            .consistencyModel(Linearizability)
            .reset { => storeBufferReg.reset() }
            .actor{ => storeBufferReg.write(1) }
            .actor{ => storeBufferReg.read() }
            .iterations(200)
            .build()
            .run()

        println("SC: ${scResult.report()}")
        println("Linearizability: ${linResult.report()}")


        for (val in linResult.consistencyValidations) {
            if (!val.isConsistent) {
                println(val.getMismatchDetails())
            }
        }

        @Assert(scResult.passed)
        @Assert(!linResult.passed)
    }

    @TestCase
    func testStoreBufferRegister_scAccepts_linearizabilityRejects2(): Unit {

        let scResult = scenario("storebuffer_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => storeBufferReg.reset() }
            .actorWithOps([operation("write", { => storeBufferReg.write(1) })])
            .actorWithOps([operation("read", { => storeBufferReg.read() })])
            .iterations(500)
            .build()
            .run()

        let linResult = scenario("storebuffer_lin")
            .consistencyModel(Linearizability)
            .reset { => storeBufferReg.reset() }
            .actorWithOps([operation("write", { => storeBufferReg.write(1) })])
            .actorWithOps([operation("read", { => storeBufferReg.read() })])
            .iterations(500)
            .build()
            .run()

        println("SC: ${scResult.report()}")
        println("Linearizability: ${linResult.report()}")

        for (val in linResult.consistencyValidations) {
            if (!val.isConsistent) {
                println(val.getMismatchDetails())
            }
        }

        @Assert(scResult.passed)
        @Assert(!linResult.passed)
    }

    @TestCase
    func testStoreBufferRegister_scAccepts_linearizabilityRejects3(): Unit {

        let scResult = scenario("storebuffer_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => storeBufferReg.reset() }
            .actorWithOps([
                operation("write", { => storeBufferReg.write(1) }),
                operation("write", { => storeBufferReg.write(2) }),
                operation("read", { => storeBufferReg.read() }),
                operation("write", { => storeBufferReg.write(3) }),
            ])
            .actorWithOps([
                operation("read", { => storeBufferReg.read() }),
                operation("read", { => storeBufferReg.read() }),
            ])
            .actorWithOps([operation("read", { => storeBufferReg.read() })])
            .iterations(500)
            .build()
            .run()

        let linResult = scenario("storebuffer_lin")
            .consistencyModel(Linearizability)
            .reset { => storeBufferReg.reset() }
            .actorWithOps([
                operation("write", { => storeBufferReg.write(1) }),
                operation("write", { => storeBufferReg.write(2) }),
                operation("read", { => storeBufferReg.read() }),
                operation("write", { => storeBufferReg.write(3) }),
            ])
            .actorWithOps([
                operation("read", { => storeBufferReg.read() }),
                operation("read", { => storeBufferReg.read() }),
            ])
            .actorWithOps([operation("read", { => storeBufferReg.read() })])
            .iterations(500)
            .build()
            .run()

        println("SC: ${scResult.report()}")
        println("Linearizability: ${linResult.report()}")

        for (val in linResult.consistencyValidations) {
            if (!val.isConsistent) {
                println(val.getMismatchDetails())
            }
        }

        @Assert(scResult.passed)
        @Assert(!linResult.passed)
    }

    @TestCase
    func testLazyTwoFieldRegister_serializableAccepts_SCRejects(): Unit {
        let specExec2F = { state: SimpleTwoFieldRegister, inv: OperationInvocation =>
            match (inv.operationName) {
                case "setX" => execResultOf({ => state.setX(1) })
                case "getY" => execResultOf({ => state.getY() })
                case "setY" => execResultOf({ => state.setY(1) })
                case "getX" => execResultOf({ => state.getX() })
                case _ => execResultOf({ => -1 })
            }
        }

        let serResult = scenario("lazy_2field_ser")
            .consistencyModel(Serializability)
            .reset { => committedX = 0; committedY = 0; pendingX = 0; pendingY = 0 }
            .actorWithOps([
                operation("setX", { => pendingX = 1; pendingX }),
                operation("getY", { => committedY }),
            ])
            .actorWithOps([
                operation("setY", { => pendingY = 1; pendingY }),
                operation("getX", { => committedX }),
            ])
            .sequentialSpec<SimpleTwoFieldRegister>(
                { => SimpleTwoFieldRegister() },
                specExec2F
            )
            .iterations(1)
            .build()
            .run()

        let scResult = scenario("lazy_2field_sc")
            .consistencyModel(SequentialConsistency)
            .reset { => committedX = 0; committedY = 0; pendingX = 0; pendingY = 0 }
            .actorWithOps([
                operation("setX", { => pendingX = 1; pendingX }),
                operation("getY", { => committedY }),
            ])
            .actorWithOps([
                operation("setY", { => pendingY = 1; pendingY }),
                operation("getX", { => committedX }),
            ])
            .sequentialSpec<SimpleTwoFieldRegister>(
                { => SimpleTwoFieldRegister() },
                specExec2F
            )
            .iterations(1)
            .build()
            .run()

        println("Serializability: ${serResult.report()}")
        println("SC: ${scResult.report()}")

        @Assert(serResult.passed)
        @Assert(!scResult.passed)
    }

    @TestCase
    func testLazyRegister_scAccepts_linearizabilityRejects(): Unit {
        let specExecReg = { state: Any, inv: OperationInvocation =>
            if (let Some(reg) <- (state as SimpleRegister)) {
                match (inv.operationName) {
                    case "write" => execResultOf({ => reg.write(1) })
                    case "read" => execResultOf({ => reg.read() })
                    case _ => execResultOf({ => -1 })
                }
            } else {
                execResultOf({ => -1 })
            }
        }

        let writeInv = newOperationInvocation(
            actorId: 0,
            operationIndex: 0,
            operationName: "write",
            result: execResultOf({ => 1 }),
            invocationVC: Some(Array<Int64>(2, { _ => 0 })),
            responseVC: Some(Array<Int64>(2, { i => if (i == 0) { 2 } else { 0 } }))
        )

        let readInv = newOperationInvocation(
            actorId: 1,
            operationIndex: 0,
            operationName: "read",
            result: execResultOf({ => 0 }),
            invocationVC: Some(Array<Int64>(2, { i => if (i == 0) { 2 } else { 1 } })),
            responseVC: Some(Array<Int64>(2, { i => if (i == 0) { 2 } else { 3 } }))
        )

        let actor0Invs = ArrayList<OperationInvocation>()
        actor0Invs.add(writeInv)
        let actor1Invs = ArrayList<OperationInvocation>()
        actor1Invs.add(readInv)

        let scResult = validateManualHistory(
            SequentialConsistency,
            [actor0Invs, actor1Invs],
            { => SimpleRegister() },
            specExecReg
        )

        let linResult = validateManualHistory(
            Linearizability,
            [actor0Invs, actor1Invs],
            { => SimpleRegister() },
            specExecReg
        )

        println("SC: ${scResult.report()}")
        println("Linearizability: ${linResult.report()}")

        @Assert(scResult.isConsistent)
        @Assert(!linResult.isConsistent)
    }
}