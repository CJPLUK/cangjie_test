/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// CT-LOOP-001~012/014~021 runtime cases. CT-LOOP-013 (checks off) is covered by
// the compile-time `contract_check` dual build (design §3.5 / R8).

import stdx.contract.macros.*

// Runtime counters shared by the cases below. Every invariant expression in
// this file is a probe: it increments the counter and/or appends a tag, so the
// test can assert both the number of check points and the evaluation order.
var loopCheckCount: Int64 = 0
var loopOrder: String = ""

func loopTick(tag: String): Bool {
    loopCheckCount += 1
    loopOrder += tag
    true
}

func loopTickFalse(tag: String): Bool {
    loopCheckCount += 1
    loopOrder += tag
    false
}

// CT-LOOP-001: a `for-in` loop runs two iterations. Design 3.2.6.2 checks the
// invariant at the start of every iteration and does not add an exit check, so
// exactly two checks happen.
@Contract
func loopForTwo(): Int64 {
    var sum = 0
    @loopInvariant[loopTick("f")](for (i in 0..2) {
        sum += i
    })
    sum
}

// CT-LOOP-002: a `while` loop runs two iterations. The invariant is checked at
// the start of each iteration and once more when the loop exits, so exactly
// three checks happen.
@Contract
func loopWhileTwo(): Int64 {
    var i = 0
    @loopInvariant[loopTick("w")](while (i < 2) {
        i += 1
    })
    i
}

// CT-LOOP-003: a `do-while` loop runs one round. The check happens after the
// body and before the condition is evaluated, so exactly one check happens.
//
// The loop condition reads a package-level variable instead of a local `var`:
// the macro lowers the do-while condition into a closure, and the compiler
// rejects a closure that captures a mutable local. This is an implementation
// restriction, not part of the documented semantics.
var loopDoWhileState: Int64 = 0

@Contract
func loopDoWhileOne(): Int64 {
    loopDoWhileState = 0
    @loopInvariant[loopTick("d")](do {
        loopDoWhileState += 1
    } while (loopDoWhileState < 1))
    loopDoWhileState
}

// CT-LOOP-004: two invariants are evaluated in source order. A while loop with
// one iteration has two check points (iteration start and exit), so the order
// is "a" then "b" twice.
@Contract
func loopTwoInvariants(): Int64 {
    var i = 0
    @loopInvariant[
        loopTick("a")
        loopTick("b")
    ](while (i < 1) {
        i += 1
    })
    i
}

// CT-LOOP-005: the first invariant is false and the second one carries a side
// effect. Evaluation stops at the first failing invariant, so the second probe
// must not run.
@Contract
func loopFirstFails(): Unit {
    var i = 0
    @loopInvariant[
        loopTickFalse("first")
        loopTick("second")
    ](while (i < 1) {
        i += 1
    })
}

// CT-LOOP-006: any false invariant raises ContractCheckLoopInvariantException.
// The message names the failing check and the invariant expression.
@Contract
func loopInvariantFalse(fail: Bool): Int64 {
    var i = 0
    @loopInvariant[!fail](while (i < 1) {
        i += 1
    })
    i
}

// CT-LOOP-007: a `for-in` invariant may use the loop variable. The first
// function keeps the bounds valid; the second one uses a too-small bound so the
// third iteration observes i == 2 and fails.
@Contract
func loopForVariable(): Int64 {
    var sum = 0
    @loopInvariant[i >= 0 && i < 3](for (i in 0..3) {
        sum += i
    })
    sum
}

@Contract
func loopForVariableFails(): Int64 {
    var sum = 0
    @loopInvariant[i < 2](for (i in 0..3) {
        sum += i
    })
    sum
}

// CT-LOOP-009: `break` leaves the loop early. A `for-in` loop has no exit
// check, so only the iteration-start checks performed before the break remain.
// A `while` loop still executes its documented exit check after the break.
@Contract
func loopBreakWhile(): Int64 {
    var i = 0
    @loopInvariant[loopTick("b")](while (i < 5) {
        i += 1
        if (i == 2) {
            break
        }
    })
    i
}

@Contract
func loopBreakFor(): Int64 {
    var count = 0
    @loopInvariant[loopTick("bf")](for (i in 0..5) {
        count += 1
        if (i == 1) {
            break
        }
    })
    count
}

// CT-LOOP-010: `continue` skips the rest of the body, but the next iteration
// start is still a check point. Three iterations plus the while exit check
// yield four checks.
@Contract
func loopContinue(): Int64 {
    var i = 0
    @loopInvariant[loopTick("c")](while (i < 3) {
        i += 1
        if (i == 2) {
            continue
        }
    })
    i
}

// CT-LOOP-011: `return` leaves the function before the loop-exit check is
// emitted, so only the two iteration-start checks that already happened are
// observed.
@Contract
func loopReturn(): Int64 {
    var i = 0
    @loopInvariant[loopTick("r")](while (i < 5) {
        i += 1
        if (i == 2) {
            return i
        }
    })
    -1
}

// CT-LOOP-012: two nested `for-in` loops, each with its own invariant. The
// outer invariant is checked once per outer iteration (2); the inner invariant
// is checked once per inner iteration, i.e. 2 x 2 = 4 times.
var loopOuterChecks: Int64 = 0
var loopInnerChecks: Int64 = 0

func loopOuterTick(): Bool {
    loopOuterChecks += 1
    true
}

func loopInnerTick(): Bool {
    loopInnerChecks += 1
    true
}

@Contract
func loopNested(): Int64 {
    var count = 0
    @loopInvariant[loopOuterTick()](for (i in 0..2) {
        @loopInvariant[loopInnerTick()](for (j in 0..2) {
            count += 1
        })
    })
    count
}

// CT-LOOP-014: an invariant calls a function whose own precondition is
// `requires false`. Contract evaluation is re-entrant-suppressed, so the inner
// precondition is not checked and the invariant is judged normally.
@Contract[
    requires false
]
func loopRequiresFalse(): Bool {
    true
}

@Contract
func loopNestedSuppression(): Int64 {
    var i = 0
    @loopInvariant[loopRequiresFalse()](while (i < 1) {
        i += 1
    })
    i
}

// CT-LOOP-017: the loop condition throws a business exception. Design 3.2.6.2
// leaves this case to DT design doc 20/R7; the current implementation lets the
// exception propagate unchanged and the loop-exit invariant check is not
// reached. The condition returns true once, so exactly one iteration-start
// check has happened before the throw.
class LoopBusinessException <: Exception {
    init(message: String) {
        super(message)
    }
}

var loopConditionCalls: Int64 = 0
var loopConditionThrowAt: Int64 = 0

func loopThrowingCondition(): Bool {
    loopConditionCalls += 1
    if (loopConditionCalls >= loopConditionThrowAt) {
        throw LoopBusinessException("loop condition failure")
    }
    true
}

@Contract
func loopBusinessCondition(): Int64 {
    loopConditionCalls = 0
    loopConditionThrowAt = 2
    var i = 0
    @loopInvariant[loopTick("t")](while (loopThrowingCondition()) {
        i += 1
    })
    i
}

// CT-LOOP-020: a `while` loop with zero iterations still checks once at the
// exit point, per design 3.2.6.2.
@Contract
func loopWhileZero(): Int64 {
    var i = 0
    @loopInvariant[loopTick("z")](while (i < 0) {
        i += 1
    })
    i
}

// CT-LOOP-021: multiple conditions are checked one by one (design 3.2.6.2,
// L396 "按顺序检查"), so the failure message pinpoints the failing condition
// instead of quoting the whole invariant group. The first condition passes and
// the second one fails; each probe still runs exactly once.
@Contract
func loopSecondConditionFails(): Unit {
    var i = 0
    @loopInvariant[
        loopTick("first")
        loopTickFalse("second")
    ](while (i < 1) {
        i += 1
    })
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        loopCheckCount = 0
        loopOrder = ""
        loopDoWhileState = 0
        loopOuterChecks = 0
        loopInnerChecks = 0
        loopConditionCalls = 0
        loopConditionThrowAt = 0
    }

    @AfterEach
    func tearDown(): Unit {
        loopCheckCount = 0
        loopOrder = ""
        loopDoWhileState = 0
        loopOuterChecks = 0
        loopInnerChecks = 0
        loopConditionCalls = 0
        loopConditionThrowAt = 0
    }

    // CT-LOOP-001: two iterations, two checks, and the loop computes 0 + 1.
    @TestCase
    func testLoop001ForTwoIterations() {
        @Expect(loopForTwo(), 1)
        @Expect(loopCheckCount, 2)
        @Expect(loopOrder, "ff")
    }

    // CT-LOOP-002: two iterations plus one exit check.
    @TestCase
    func testLoop002WhileTwoIterations() {
        @Expect(loopWhileTwo(), 2)
        @Expect(loopCheckCount, 3)
        @Expect(loopOrder, "www")
    }

    // CT-LOOP-003: one round of the body, one check before the condition.
    @TestCase
    func testLoop003DoWhileOneRound() {
        @Expect(loopDoWhileOne(), 1)
        @Expect(loopCheckCount, 1)
        @Expect(loopOrder, "d")
    }

    // CT-LOOP-004: both invariants run in source order at every check point.
    @TestCase
    func testLoop004InvariantOrder() {
        @Expect(loopTwoInvariants(), 1)
        @Expect(loopCheckCount, 4)
        @Expect(loopOrder, "abab")
    }

    // CT-LOOP-005: the first invariant fails, so the side-effecting second one
    // is never evaluated.
    @TestCase
    func testLoop005FirstFailureShortCircuits() {
        var caught = false
        try {
            loopFirstFails()
        } catch (e: ContractCheckLoopInvariantException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
        @Expect(loopCheckCount, 1)
        @Expect(loopOrder, "first")
    }

    // CT-LOOP-006: a false single invariant raises the dedicated exception with
    // a locating message.
    @TestCase
    func testLoop006ViolationException() {
        @Expect(loopInvariantFalse(false), 1)

        var caught = false
        try {
            loopInvariantFalse(true)
        } catch (e: ContractCheckLoopInvariantException) {
            caught = true
            @Expect(e.message.contains("loop invariant failed"), true)
            @Expect(e.message.contains("! fail"), true)
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // CT-LOOP-007: the for-loop variable is visible to the invariant. A valid
    // bound passes; a bound of i < 2 fails when i reaches 2.
    @TestCase
    func testLoop007ForVariableVisible() {
        @Expect(loopForVariable(), 3)

        var caught = false
        try {
            loopForVariableFails()
        } catch (e: ContractCheckLoopInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-LOOP-009: a for-in break stops checks at the last started iteration
    // (2); a while break still runs the exit check (2 starts + 1 exit = 3).
    @TestCase
    func testLoop009Break() {
        @Expect(loopBreakWhile(), 2)
        @Expect(loopCheckCount, 3)
        @Expect(loopOrder, "bbb")

        loopCheckCount = 0
        loopOrder = ""
        @Expect(loopBreakFor(), 2)
        @Expect(loopCheckCount, 2)
        @Expect(loopOrder, "bfbf")
    }

    // CT-LOOP-010: continue keeps the iteration-start check point; three
    // iterations plus the exit check yield four checks.
    @TestCase
    func testLoop010Continue() {
        @Expect(loopContinue(), 3)
        @Expect(loopCheckCount, 4)
        @Expect(loopOrder, "cccc")
    }

    // CT-LOOP-011: return skips the pending exit check; only the two checks
    // that already happened are observed.
    @TestCase
    func testLoop011Return() {
        @Expect(loopReturn(), 2)
        @Expect(loopCheckCount, 2)
        @Expect(loopOrder, "rr")
    }

    // CT-LOOP-012: each loop checks at its own check points independently.
    @TestCase
    func testLoop012NestedLoops() {
        @Expect(loopNested(), 4)
        @Expect(loopOuterChecks, 2)
        @Expect(loopInnerChecks, 4)
    }

    // CT-LOOP-014: the inner `requires false` is suppressed while the invariant
    // is evaluated; a direct call outside the invariant still reports it.
    @TestCase
    func testLoop014NestedContractSuppressed() {
        @Expect(loopNestedSuppression(), 1)

        var caught = false
        try {
            loopRequiresFalse()
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(e.message.contains("requires false"), true)
        }
        @Expect(caught, true)
    }

    // CT-LOOP-017: the business exception raised by the loop condition
    // propagates unchanged, the exit invariant check does not run, and the
    // evaluation depth is restored for later checks.
    @TestCase
    func testLoop017BusinessExceptionInCondition() {
        var caught = false
        try {
            loopBusinessCondition()
        } catch (e: LoopBusinessException) {
            caught = true
            @Expect(e.message, "loop condition failure")
            @Expect(isContractException(e), false)
        }
        @Expect(caught, true)
        @Expect(loopCheckCount, 1)
        @Expect(loopOrder, "t")

        // The evaluation depth was restored, so a later invariant violation is
        // still reported.
        var contractCaught = false
        try {
            loopInvariantFalse(true)
        } catch (e: ContractCheckLoopInvariantException) {
            contractCaught = true
        }
        @Expect(contractCaught, true)
    }

    // CT-LOOP-020: zero iterations still yield one check at the while exit.
    @TestCase
    func testLoop020WhileZeroIterations() {
        @Expect(loopWhileZero(), 0)
        @Expect(loopCheckCount, 1)
        @Expect(loopOrder, "z")
    }

    // CT-LOOP-021: the message names only the failing condition; both probes
    // run once in order before the failure is raised.
    @TestCase
    func testLoop021PerConditionFailureMessage() {
        var caught = false
        try {
            loopSecondConditionFails()
        } catch (e: ContractCheckLoopInvariantException) {
            caught = true
            @Expect(e.message.contains("loop invariant failed"), true)
            @Expect(e.message.contains("second"), true)
            @Expect(e.message.contains("first"), false)
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
        @Expect(loopCheckCount, 2)
        @Expect(loopOrder, "firstsecond")
    }
}
