/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*
import std.collection.*
import std.sync.*

// Note: CT-RUN-017 (repeated toggle idempotency) was removed together with the
// runtime switch APIs setCheckContract()/unsetCheckContract() (design §3.5
// change: the switch is decided only by the compile-time
// `--cfg "contract_check=on"`); disabled-state behaviour is covered by the
// contract_verify cases in the stdx tree.

// ---------- shared fixtures ----------

class Probe {
    var count: Int64 = 0
}

class BizException <: Exception {
    public init(msg: String) {
        super(msg)
    }
}

class ExA <: Exception {
    public init(msg: String) {
        super(msg)
    }
}

class ExB <: Exception {
    public init(msg: String) {
        super(msg)
    }
}

// CT-RUN-001/002: a function whose `requires false` must be suppressed while its
// call happens inside another function's contract expression (re-entrant evaluation).
var innerCalls: Int64 = 0

@Contract[
    requires false
]
func innerViolating(): Int64 {
    innerCalls += 1
    1
}

@Contract[
    requires (innerViolating() == 1)
]
func outerCallsInner(): Unit {
}

// CT-RUN-003: re-entrant evaluation followed by a business exception thrown from
// the outer body; the evaluation depth must be restored on the exceptional path.
@Contract[
    requires (innerViolating() == 1)
]
func outerThenBizThrow(): Unit {
    throw BizException("biz after reentry")
}

// CT-RUN-004: records `contractInEvaluation()` observed inside a contract expression.
var evalRecord: Bool = false

func recordInEval(): Bool {
    evalRecord = contractInEvaluation()
    true
}

@Contract[
    requires recordInEval()
]
func evalProbe(): Unit {
}

// CT-RUN-005: every contract exception kind defined in design 3.5.1.
func buildAllContractExceptions(): ArrayList<Exception> {
    let list = ArrayList<Exception>()
    list.add(ContractCheckRequiresException())
    list.add(ContractCheckEnsuresException())
    list.add(ContractCheckThrowsException())
    list.add(ContractCheckAssertException())
    list.add(ContractCheckLoopInvariantException())
    list.add(ContractCheckInvariantException())
    list.add(ContractCheckGhostStateException())
    list
}

// CT-RUN-007: declares `throws ExA`, but the body throws ExB -> the throws contract
// is violated and ContractCheckThrowsException must carry ExB as its cause.
@Contract[
    throws ExA if (true)
]
func throwsWrongType(): Unit {
    throw ExB("unexpected business exception")
}

// CT-RUN-008: message must contain the function name and the failed clause.
@Contract[
    requires (1 > 2)
]
func msgProbeFunc(): Unit {
}

@Contract
class MsgClass {
    @Contract[
        requires false
    ]
    public func broken(): Unit {
    }
}

// CT-RUN-009: plain reject probe reused by the concurrency cases.
@Contract[
    requires false
]
func rejectAlways(probe: Probe): Unit {
    probe.count += 1
}

@Contract[
    requires true
]
func okContract(): Int64 {
    42
}

// CT-RUN-010: concurrent `mut`-style calls on one shared object; the contract must
// not introduce implicit locking.
class SharedMut {
    var v: Int64 = 0

    @Contract[
        requires (v < 1000000)
    ]
    public func bump(): Unit {
        v += 1
    }
}

// CT-RUN-012: every recursive call carries a contract; each level is checked.
var reqChecks: Int64 = 0

func countReq(): Bool {
    reqChecks += 1
    true
}

@Contract[
    requires countReq()
]
func fact(n: Int64): Int64 {
    if (n <= 1) {
        1
    } else {
        n * fact(n - 1)
    }
}

// CT-RUN-013: the contract expression calls the function itself; re-entrancy
// suppression must prevent infinite recursion.
@Contract[
    requires (selfInContract(n - 1) >= 0)
]
func selfInContract(n: Int64): Int64 {
    if (n <= 0) {
        0
    } else {
        selfInContract(n - 1)
    }
}

// CT-RUN-019: evaluation counter for snapshot probes.
var snapshotEvalCount: Int64 = 0

func snapshotValue(): Int64 {
    snapshotEvalCount += 1
    7
}

// ---------- test cases ----------

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
    }

    @AfterEach
    func tearDown(): Unit {
    }

    // CT-RUN-001: with checking enabled, an inner function called from the outer
    // contract expression has its contract suppressed; no inner exception is thrown.
    @TestCase
    func testRun001InnerContractSuppressed() {
        innerCalls = 0
        outerCallsInner()
        @Expect(innerCalls, 1)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-002: after the re-entrant evaluation above the depth is back to zero,
    // so subsequent calls are checked normally again.
    @TestCase
    func testRun002DepthResetAfterReentry() {
        innerCalls = 0
        outerCallsInner()
        @Expect(contractInEvaluation(), false)

        let probe = Probe()
        var caught = false
        try {
            rejectAlways(probe)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(probe.count, 0)
    }

    // CT-RUN-003: a business exception thrown after a re-entrant evaluation must
    // still leave the depth at zero; the next contract call is checked normally.
    @TestCase
    func testRun003DepthResetAfterBizException() {
        innerCalls = 0
        var bizCaught = false
        try {
            outerThenBizThrow()
        } catch (e: BizException) {
            bizCaught = true
        }
        @Expect(bizCaught, true)
        @Expect(innerCalls, 1)
        @Expect(contractInEvaluation(), false)

        let probe = Probe()
        var caught = false
        try {
            rejectAlways(probe)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(probe.count, 0)
    }

    // CT-RUN-004: contractInEvaluation() is false outside contracts and true while
    // a contract expression is being evaluated.
    @TestCase
    func testRun004InEvaluationFlag() {
        @Expect(contractInEvaluation(), false)

        evalRecord = false
        evalProbe()
        @Expect(evalRecord, true)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-005: isContractException() returns true for all seven contract
    // exception kinds.
    @TestCase
    func testRun005IsContractExceptionTrueForAll() {
        for (e in buildAllContractExceptions()) {
            @Expect(isContractException(e), true)
        }
    }

    // CT-RUN-006: isContractException() returns false for ordinary business
    // exceptions.
    @TestCase
    func testRun006IsContractExceptionFalseForBiz() {
        @Expect(isContractException(BizException("biz")), false)
        @Expect(isContractException(ExA("a")), false)
    }

    // CT-RUN-007: when the body throws an exception outside the declared `throws`
    // type, ContractCheckThrowsException carries the original exception as cause.
    @TestCase
    func testRun007ThrowsViolationCarriesCause() {
        var caught = false
        try {
            throwsWrongType()
        } catch (e: ContractCheckThrowsException) {
            caught = true
            @Expect(e.cause.isSome(), true)
            match (e.cause) {
                case Some(original) =>
                    @Expect(original is ExB, true)
                    @Expect(original.message, "unexpected business exception")
                case None =>
                    @Expect(false, true)
            }
        }
        @Expect(caught, true)
    }

    // CT-RUN-008: a failed check reports the owner function name and the failed
    // clause text in the exception message, for both global functions and members.
    @TestCase
    func testRun008DiagnosticMessage() {
        var funcCaught = false
        try {
            msgProbeFunc()
        } catch (e: ContractCheckRequiresException) {
            funcCaught = true
            @Expect(e.message.contains("msgProbeFunc"), true)
            @Expect(e.message.contains("requires"), true)
            @Expect(e.message.contains("1 > 2"), true)
        }
        @Expect(funcCaught, true)

        var memberCaught = false
        try {
            MsgClass().broken()
        } catch (e: ContractCheckRequiresException) {
            memberCaught = true
            @Expect(e.message.contains("broken"), true)
            @Expect(e.message.contains("requires false"), true)
        }
        @Expect(memberCaught, true)
    }

    // CT-RUN-009: threads calling contract functions concurrently check their own
    // contracts independently; the per-thread evaluation depth does not leak.
    @TestCase
    func testRun009ConcurrentIndependentChecks() {
        let caughtTotal = AtomicInt64(0)
        let okTotal = AtomicInt64(0)
        let futures = ArrayList<Future<Unit>>()
        for (i in 0..8) {
            futures.add(spawn {
                for (j in 0..10) {
                    var caught = false
                    try {
                        rejectAlways(Probe())
                    } catch (e: ContractCheckRequiresException) {
                        caught = true
                    }
                    if (caught) {
                        caughtTotal.fetchAdd(1)
                    }
                    if (okContract() == 42) {
                        okTotal.fetchAdd(1)
                    }
                }
            })
        }
        for (f in futures) {
            f.get()
        }
        @Expect(caughtTotal.load(), 80)
        @Expect(okTotal.load(), 80)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-010: concurrent calls on one shared object finish without deadlock;
    // the contract check adds no implicit locking, so the final value may lose
    // updates but never exceeds the total number of calls.
    @TestCase
    func testRun010ConcurrentMutNoDeadlock() {
        let target = SharedMut()
        let futures = ArrayList<Future<Unit>>()
        for (i in 0..8) {
            futures.add(spawn {
                for (j in 0..100) {
                    target.bump()
                }
            })
        }
        for (f in futures) {
            f.get()
        }
        @Expect(target.v <= 800, true)
        @Expect(target.v >= 1, true)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-011: the switch is fixed at compile time; concurrent calls from
    // multiple threads are all checked. Every call must throw
    // ContractCheckRequiresException and the function body must not run.
    @TestCase
    func testRun011ConcurrentCallsAllChecked() {
        let caughtTotal = AtomicInt64(0)
        let skippedTotal = AtomicInt64(0)
        let futures = ArrayList<Future<Unit>>()
        for (i in 0..2) {
            futures.add(spawn {
                for (j in 0..20) {
                    let p = Probe()
                    var caught = false
                    try {
                        rejectAlways(p)
                    } catch (e: ContractCheckRequiresException) {
                        caught = true
                    }
                    if (caught) {
                        caughtTotal.fetchAdd(1)
                    }
                    if (p.count == 0) {
                        skippedTotal.fetchAdd(1)
                    }
                }
            })
        }
        for (f in futures) {
            f.get()
        }
        @Expect(caughtTotal.load(), 40)
        @Expect(skippedTotal.load(), 40)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-012: a recursive function with a contract checks every level
    // independently (fact(5) recurses through 5 calls, none suppressed or
    // overwritten).
    @TestCase
    func testRun012RecursionCheckedPerLevel() {
        reqChecks = 0
        let r = fact(5)
        @Expect(r, 120)
        @Expect(reqChecks, 5)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-013: a contract expression that calls the function itself does not
    // recurse infinitely; re-entrancy suppression ends the evaluation.
    @TestCase
    func testRun013SelfCallInContractSuppressed() {
        let r = selfInContract(3)
        @Expect(r, 0)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-014: a contract exception propagates through two try/finally layers;
    // every finally body runs and the evaluation depth ends at zero.
    @TestCase
    func testRun014ExceptionThroughTwoFinally() {
        var finally1 = false
        var finally2 = false
        var caught = false
        try {
            try {
                try {
                    rejectAlways(Probe())
                } finally {
                    finally1 = true
                }
            } finally {
                finally2 = true
            }
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(finally1, true)
        @Expect(finally2, true)
        @Expect(caught, true)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-015: 100 spawned tasks all calling a contract function return
    // normally; every Future.get() succeeds with the expected result.
    @TestCase
    func testRun015HundredTasksAllPass() {
        let futures = ArrayList<Future<Int64>>()
        for (i in 0..100) {
            let n = i
            futures.add(spawn {
                okContract() + n
            })
        }
        var sum: Int64 = 0
        for (f in futures) {
            sum += f.get()
        }
        // 100 * 42 + sum(0..99)
        @Expect(sum, 4200 + 4950)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-016: a contract failure in a child thread propagates the original
    // contract exception type through Future.get() unchanged.
    @TestCase
    func testRun016ContractExceptionViaFuture() {
        let f = spawn {
            rejectAlways(Probe())
        }
        var caught = false
        try {
            f.get()
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-018: direct paired calls of contractEvalEnter()/contractEvalExit();
    // the depth counter behaves correctly through nesting.
    // This is a regression guard for the macro-support API; users should not call
    // it directly (see DT design doc section 19 coverage note).
    @TestCase
    func testRun018EvalEnterExitDepth() {
        @Expect(contractInEvaluation(), false)
        contractEvalEnter()
        @Expect(contractInEvaluation(), true)
        contractEvalEnter()
        @Expect(contractInEvaluation(), true)
        contractEvalExit()
        @Expect(contractInEvaluation(), true)
        contractEvalExit()
        @Expect(contractInEvaluation(), false)
        // An extra exit is an underflow absorbed as a no-op: the depth stays unset and
        // the evaluation flag remains cleared. The stdx v2 line replaced the old
        // IllegalStateException from the 16.43 fix with a silent clear — a throw inside
        // a finally block would mask the business exception.
        contractEvalExit()
        @Expect(contractInEvaluation(), false)
    }

    // CT-RUN-019: contractCaptureSnapshot evaluates the closure exactly once and
    // returns Some(value) when enabled; with disabled it returns None and never
    // evaluates the closure.
    // Regression guard for the macro-support API; users should not call it directly.
    @TestCase
    func testRun019CaptureSnapshot() {
        snapshotEvalCount = 0
        let enabled = contractCaptureSnapshot(true, snapshotValue)
        @Expect(snapshotEvalCount, 1)
        match (enabled) {
            case Some(v) => @Expect(v, 7)
            case None => @Expect(false, true)
        }

        snapshotEvalCount = 0
        let disabled = contractCaptureSnapshot(false, snapshotValue)
        @Expect(snapshotEvalCount, 0)
        @Expect(disabled.isNone(), true)
    }

    // CT-RUN-020: contractGhostGet unwraps Some(value); None is a ghost-state
    // violation reported as ContractCheckGhostStateException naming the variable.
    // Regression guard for the macro-support API; users should not call it directly.
    @TestCase
    func testRun020GhostGet() {
        let got = contractGhostGet(Some(42), "x")
        @Expect(got, 42)

        var caught = false
        try {
            contractGhostGet<Int64>(None, "x")
        } catch (e: ContractCheckGhostStateException) {
            caught = true
            @Expect(e.message.contains("x"), true)
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }
}
