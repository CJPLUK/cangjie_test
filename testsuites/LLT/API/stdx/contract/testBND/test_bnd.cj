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

// ---------- shared fixtures ----------

// CT-BND-001: boundary condition against Int64.Max.
@Contract[
    requires (x > Int64.Max - 1)
]
func bndNearMax(x: Int64): Int64 {
    x
}

// CT-BND-003: generic function instantiated with Option<T>. The contract only
// inspects the Option wrapper (T carries no Equatable bound).
@Contract[
    requires (v.isSome())
    ensures out: out.isSome()
]
func bndEchoOpt<T>(v: Option<T>): Option<T> {
    v
}

// CT-BND-004: short-circuit probes; each side-effecting probe records whether it
// was evaluated.
var bndAndCount: Int64 = 0
var bndOrCount: Int64 = 0

func bndFalsy(): Bool {
    bndAndCount += 1
    false
}

func bndTruthy(): Bool {
    bndOrCount += 1
    true
}

@Contract[
    requires (bndFalsy() && bndTruthy())
]
func bndShortCircuitAnd(): Unit {
}

@Contract[
    requires (bndTruthy() || bndFalsy())
]
func bndShortCircuitOr(): Unit {
}

// CT-BND-005: twenty requires and twenty ensures clauses on one function; every
// clause reports its own evaluation through the shared counters. `reqFailAt`
// flips exactly one clause to false.
var bndReqCount: Int64 = 0
var bndEnsCount: Int64 = 0
var bndReqFailAt: Int64 = 0

func bndReq(i: Int64): Bool {
    bndReqCount += 1
    i != bndReqFailAt
}

func bndEns(i: Int64): Bool {
    bndEnsCount += 1
    true
}

@Contract[
    requires bndReq(1)
    requires bndReq(2)
    requires bndReq(3)
    requires bndReq(4)
    requires bndReq(5)
    requires bndReq(6)
    requires bndReq(7)
    requires bndReq(8)
    requires bndReq(9)
    requires bndReq(10)
    requires bndReq(11)
    requires bndReq(12)
    requires bndReq(13)
    requires bndReq(14)
    requires bndReq(15)
    requires bndReq(16)
    requires bndReq(17)
    requires bndReq(18)
    requires bndReq(19)
    requires bndReq(20)
    ensures bndEns(1)
    ensures bndEns(2)
    ensures bndEns(3)
    ensures bndEns(4)
    ensures bndEns(5)
    ensures bndEns(6)
    ensures bndEns(7)
    ensures bndEns(8)
    ensures bndEns(9)
    ensures bndEns(10)
    ensures bndEns(11)
    ensures bndEns(12)
    ensures bndEns(13)
    ensures bndEns(14)
    ensures bndEns(15)
    ensures bndEns(16)
    ensures bndEns(17)
    ensures bndEns(18)
    ensures bndEns(19)
    ensures bndEns(20)
]
func bndManyClauses(): Int64 {
    1
}

// CT-BND-006: contract references a global mutable variable; `$pre` captures the
// entry value while the plain reference is re-evaluated at exit. `$pre` is an
// ensures-only construct (requires already evaluates at entry).
var bndGlobalState: Int64 = 0

@Contract[
    ensures (bndGlobalState == 2 && $pre(bndGlobalState) == 1)
]
func bndMutateGlobal(): Unit {
    bndGlobalState += 1
}

// CT-BND-007: contracts on a parameterless function returning Unit.
@Contract[
    requires true
    ensures true
]
func bndUnitNoParam(): Unit {
}

@Contract[
    requires false
]
func bndUnitNoParamViolating(): Unit {
}

// CT-BND-008: `$pre` on a struct value. The struct lives in a global variable so
// the body can mutate it (a struct parameter is immutable and a body-local cannot
// be referenced from the contract, see CT-ENS-011).
// Deviation from the DT design case (section 18, CT-BND-008): the design expected
// reference semantics like CT-ENS-008 (class), but the implementation binds the
// snapshot with `let` at entry, which copies a struct. `$pre` therefore observes
// the entry value, not the mutated one.
struct BndStruct {
    var x: Int64 = 0
}

var bndStructGlobal = BndStruct()

@Contract[
    ensures ($pre(bndStructGlobal).x + 10 == bndStructGlobal.x)
]
func bndBumpCopy(): Unit {
    bndStructGlobal.x += 10
}

@Contract[
    ensures ($pre(bndStructGlobal).x == bndStructGlobal.x)
]
func bndBumpRef(): Unit {
    bndStructGlobal.x += 10
}

// CT-BND-002: integer overflow inside the ensures expression follows the language
// semantics: the runtime arithmetic exception propagates unchanged (design 3.1.7,
// R7) and is not a contract exception.
@Contract[
    ensures value: value + v > 0
]
func bndOverflowEnsures(v: Int64): Int64 {
    v
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

    // CT-BND-001: `requires x > Int64.Max - 1` evaluates with the language
    // semantics: Int64.Max passes, Int64.Max - 1 is rejected, matching a
    // handwritten expression.
    @TestCase
    func testBnd001Int64MaxBoundary() {
        @Expect(Int64.Max > Int64.Max - 1, true)

        let ok = bndNearMax(Int64.Max)
        @Expect(ok, Int64.Max)

        var caught = false
        try {
            bndNearMax(Int64.Max - 1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(e.message.contains("Int64.Max - 1"), true)
        }
        @Expect(caught, true)
    }

    // CT-BND-002: an arithmetic overflow raised while evaluating the ensures
    // expression propagates as the original language exception; it is not
    // reported as a contract exception.
    @TestCase
    func testBnd002EnsuresOverflow() {
        var caught = false
        try {
            let r = bndOverflowEnsures(Int64.Max)
            @Expect(r, Int64.Max)
        } catch (e: Exception) {
            caught = true
            @Expect(isContractException(e), false)
        }
        @Expect(caught, true)
    }

    // CT-BND-003: a generic function instantiated with Option<T> handles the
    // non-empty case normally and rejects None through requires.
    @TestCase
    func testBnd003GenericOption() {
        let some = bndEchoOpt(Some(42))
        @Expect(some.isSome(), true)
        @Expect(some.getOrThrow(), 42)

        let none: Option<Int64> = None
        var caught = false
        try {
            bndEchoOpt(none)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-BND-004: `&&`/`||` short-circuit inside contract expressions behaves like
    // ordinary expressions; the not-taken branch has no side effect.
    @TestCase
    func testBnd004ShortCircuit() {
        bndAndCount = 0
        bndOrCount = 0
        var andCaught = false
        try {
            bndShortCircuitAnd()
        } catch (e: ContractCheckRequiresException) {
            andCaught = true
        }
        @Expect(andCaught, true)
        @Expect(bndAndCount, 1) // bndFalsy evaluated, bndTruthy skipped

        var orCaught = false
        try {
            bndShortCircuitOr()
        } catch (e: ContractCheckRequiresException) {
            orCaught = true
        }
        // `truthy() || falsy()` holds, so the call passes while the second
        // branch was never evaluated.
        @Expect(orCaught, false)
        @Expect(bndOrCount, 1)
    }

    // CT-BND-005: with all twenty requires and twenty ensures satisfied, every
    // clause is evaluated exactly once. With a single failing clause the check
    // stops there and reports the requires violation.
    @TestCase
    func testBnd005TwentyClausesAllPass() {
        bndReqCount = 0
        bndEnsCount = 0
        bndReqFailAt = 0

        let r = bndManyClauses()
        @Expect(r, 1)
        @Expect(bndReqCount, 20)
        @Expect(bndEnsCount, 20)
    }

    // CT-BND-005 (single failure): flipping clause 13 makes the call fail at that
    // clause; later clauses are not evaluated and no ensures clause runs.
    @TestCase
    func testBnd005TwentyClausesSingleFailure() {
        bndReqCount = 0
        bndEnsCount = 0
        bndReqFailAt = 13

        var caught = false
        try {
            bndManyClauses()
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(bndReqCount, 13)
        @Expect(bndEnsCount, 0)
    }

    // CT-BND-006: `$pre(global)` captures the entry value while the plain global
    // reference is re-evaluated at exit, so both the entry (1) and exit (2) values
    // are observable in one contract.
    @TestCase
    func testBnd006GlobalMutableState() {
        bndGlobalState = 1

        bndMutateGlobal()
        @Expect(bndGlobalState, 2)
    }

    // CT-BND-007: a parameterless Unit function carries contracts normally, both
    // when they hold and when they are violated.
    @TestCase
    func testBnd007UnitNoParam() {
        bndUnitNoParam()

        var caught = false
        try {
            bndUnitNoParamViolating()
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-BND-008: `$pre` on a struct captures a copy at entry (implementation
    // deviation from the design's reference-semantics expectation). The passing
    // contract observes entry + 10; a reference-semantics condition fails because
    // `$pre` still sees the entry value after the body mutated the struct.
    @TestCase
    func testBnd008StructPreSnapshot() {
        bndStructGlobal.x = 1
        bndBumpCopy()
        @Expect(bndStructGlobal.x, 11)

        bndStructGlobal.x = 1
        var caught = false
        try {
            bndBumpRef()
        } catch (e: ContractCheckEnsuresException) {
            // Under reference semantics this clause would hold after the mutation;
            // it fails, proving `$pre` copied the struct at entry.
            caught = true
        }
        @Expect(caught, true)
        @Expect(bndStructGlobal.x, 11)
    }
}
