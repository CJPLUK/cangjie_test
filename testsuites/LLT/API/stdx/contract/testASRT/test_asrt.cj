/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-ASRT-001~004/007/008 runtime cases. CT-ASRT-005 is a compile-negative in
// test_asrt_005_local_before_decl.cj; CT-ASRT-006 (checks off) is covered by
// the compile-time `contract_check` dual build (design §3.5 / R8).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// ---------- shared state and helpers ----------

var asrtGlobal: Int64 = 7
var asrtSecondRan = 0

func asrtSideEffect(): Bool {
    asrtSecondRan += 1
    true
}

class AsrtBusinessException <: Exception {
    public init() {
        super("asrt biz")
    }
}

func asrtBoom(): Bool {
    throw AsrtBusinessException()
}

// CT-ASRT-007: the inner function always violates `requires`.
@Contract[
    requires false
]
func asrtInnerReject(x: Int64): Int64 {
    x
}

// CT-ASRT-004: member reference target.
class AsrtMember {
    public var m: Int64 = 3

    @Contract
    public func check(): Unit {
        @contractAssert(m == 3)
    }
}

// CT-ASRT-004: parameter, local, global and auxiliary references.
@Contract[
    variable aux: Int64 = 5
]
func asrtRefs(x: Int64): Unit {
    let local = x
    @contractAssert(x > 0)
    @contractAssert(local == x)
    @contractAssert(asrtGlobal == 7)
    @contractAssert(aux == 5)
}

// ---------- contract fixtures ----------

// CT-ASRT-001: a true assertion lets the function return normally.
@Contract
func asrtTrue(): Unit {
    @contractAssert(1 < 2)
}

// CT-ASRT-002: a false assertion throws ContractCheckAssertException.
@Contract
func asrtFalse(): Unit {
    @contractAssert(1 > 2)
}

// CT-ASRT-003: the second assertion is not evaluated after the first fails.
@Contract
func asrtMultiShortCircuit(): Unit {
    @contractAssert(false)
    @contractAssert(asrtSideEffect())
}

// CT-ASRT-007: a `requires false` function called from inside an assertion is
// not re-checked (nested evaluation suppression); the assertion verdict alone
// decides.
@Contract
func asrtNestedSuppressed(): Unit {
    @contractAssert(asrtInnerReject(1) == 1)
}

// CT-ASRT-008: a business exception raised inside the assertion expression
// passes through unchanged.
@Contract
func asrtCondThrows(): Unit {
    @contractAssert(asrtBoom())
}

@Test
class Test {
    // CT-ASRT-001
    @TestCase
    func testAsrt001TrueAssertPasses() {
        var failed = false
        try {
            asrtTrue()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-ASRT-002
    @TestCase
    func testAsrt002FalseAssertThrows() {
        var caught = false
        try {
            asrtFalse()
        } catch (e: ContractCheckAssertException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-ASRT-003
    @TestCase
    func testAsrt003ShortCircuit() {
        asrtSecondRan = 0
        var caught = false
        try {
            asrtMultiShortCircuit()
        } catch (e: ContractCheckAssertException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(asrtSecondRan, 0)
    }

    // CT-ASRT-004
    @TestCase
    func testAsrt004ReferenceTargets() {
        var failed = false
        try {
            asrtRefs(1)
            AsrtMember().check()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-ASRT-007
    @TestCase
    func testAsrt007NestedCheckSuppressed() {
        var failed = false
        try {
            asrtNestedSuppressed()
        } catch (e: ContractCheckRequiresException) {
            failed = true
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-ASRT-008
    @TestCase
    func testAsrt008BusinessExceptionPassthrough() {
        var passthrough = false
        try {
            asrtCondThrows()
        } catch (e: AsrtBusinessException) {
            passthrough = true
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)
    }
}
