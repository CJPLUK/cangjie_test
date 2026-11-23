/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-THR-001~010/012~014 runtime cases. CT-THR-009's local-variable half is a
// compile-negative in test_thr_009_throws_local.cj; CT-THR-011 (checks off) is
// covered by the compile-time `contract_check` dual build (design §3.5 / R8).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// ---------- exception fixtures ----------

class ThrExA <: Exception {
    public init() {
        super("ThrExA")
    }
}

class ThrExB <: Exception {
    public init() {
        super("ThrExB")
    }
}

open class ThrBaseEx <: Exception {
    public init() {
        super("ThrBaseEx")
    }
}

class ThrDerivedEx <: ThrBaseEx {
    public init() {
        super()
    }
}

// ---------- shared state and helpers ----------

var thrFlag = true

// CT-THR-009: member state referenced from a `throws` condition.
class ThrMember {
    public var limit: Int64 = 0

    @Contract[
        throws ThrExA if (limit > 10)
    ]
    public func touch(): Unit {}
}

// CT-THR-009: function-level auxiliary variable referenced by a `throws` cond.
@Contract[
    variable gate: Bool = true
    throws ThrExA if (gate)
]
func thrAuxCond(): Unit {}

// CT-THR-013: the condition expression itself throws a business exception.
func thrCondBoom(): Bool {
    throw IllegalArgumentException("cond boom")
}

// ---------- contract fixtures ----------

// CT-THR-001: cond true and the declared exception is thrown -> passthrough.
@Contract[
    throws ThrExA if (flag)
]
func thrDeclaredType(flag: Bool): Unit {
    if (flag) {
        throw ThrExA()
    }
}

// CT-THR-002/004: cond true with a normal return violates; cond false with a
// normal return is fine.
@Contract[
    throws ThrExA if (flag)
]
func thrSilentReturn(flag: Bool): Unit {}

// CT-THR-003/005: cond true with an unrelated exception is a violation whose
// cause is the original exception; cond false with any exception passes.
@Contract[
    throws ThrExA if (flag)
]
func thrUnrelated(flag: Bool): Unit {
    if (flag) {
        throw IllegalArgumentException("unrelated")
    }
}

@Contract[
    throws ThrExA if (flag)
]
func thrCondFalseThrows(flag: Bool): Unit {
    if (!flag) {
        throw ThrExB()
    }
}

// CT-THR-006: two true conditions declared ExA then ExB; the body throws ExB,
// which does not satisfy the first declaration.
@Contract[
    throws ThrExA if (flag)
    throws ThrExB if (flag)
]
func thrOrder(flag: Bool): Unit {
    if (flag) {
        throw ThrExB()
    }
}

// CT-THR-007: a subclass instance satisfies a clause declared with the base.
@Contract[
    throws ThrBaseEx if (flag)
]
func thrSubtype(flag: Bool): Unit {
    if (flag) {
        throw ThrDerivedEx()
    }
}

// CT-THR-008: the clause type is a generic parameter; instantiation resolves it.
@Contract[
    throws T if (flag)
]
func thrGeneric<T>(flag: Bool, ex: Exception): Unit {
    if (flag) {
        throw ex
    }
}

// CT-THR-009: global variable referenced by a `throws` condition.
@Contract[
    throws ThrExA if (thrFlag)
]
func thrGlobalCond(): Unit {}

// CT-THR-010: the condition is snapshotted at entry; mutating the state in the
// body does not affect the verdict of a normal return.
@Contract[
    throws ThrExA if (thrFlag)
]
func thrEntrySnapshot(): Unit {
    thrFlag = false
}

// CT-THR-012: with both clauses present an exceptional exit only checks
// `throws`; `ensures` is not evaluated.
@Contract[
    throws ThrExA if (flag)
    ensures false
]
func thrThrowsOverEnsures(flag: Bool): Unit {
    if (flag) {
        throw ThrExA()
    }
}

// CT-THR-013: business exception raised while evaluating the condition passes
// through unchanged.
@Contract[
    throws ThrExA if (thrCondBoom())
]
func thrCondThrows(): Unit {}

// CT-THR-014: a named clause behaves like an unnamed one.
@Contract[
    throws [t1] ThrExA if (flag)
]
func thrNamedThrow(flag: Bool): Unit {
    if (flag) {
        throw ThrExA()
    }
}

@Contract[
    throws [t1] ThrExA if (flag)
]
func thrNamedSilent(flag: Bool): Unit {}

@Test
class Test {
    // CT-THR-001: the declared exception passes through untouched.
    @TestCase
    func testThr001DeclaredTypePassthrough() {
        var passthrough = false
        try {
            thrDeclaredType(true)
        } catch (e: ThrExA) {
            passthrough = true
        } catch (e: ContractCheckThrowsException) {
            passthrough = false
        }
        @Expect(passthrough, true)
    }

    // CT-THR-002: cond true plus normal return -> ContractCheckThrowsException.
    @TestCase
    func testThr002SilentReturnViolates() {
        var caught = false
        try {
            thrSilentReturn(true)
        } catch (e: ContractCheckThrowsException) {
            // Normal return means there is no original exception.
            caught = match (e.cause) {
                case None => true
                case Some(_) => false
            }
        }
        @Expect(caught, true)
    }

    // CT-THR-003: an unrelated exception is wrapped, cause preserved.
    @TestCase
    func testThr003UnrelatedWrapped() {
        var caught = false
        try {
            thrUnrelated(true)
        } catch (e: ContractCheckThrowsException) {
            caught = match (e.cause) {
                case Some(c) => c is IllegalArgumentException
                case None => false
            }
        }
        @Expect(caught, true)
    }

    // CT-THR-004: cond false plus normal return -> no violation.
    @TestCase
    func testThr004CondFalseNormalReturn() {
        var failed = false
        try {
            thrSilentReturn(false)
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)
    }

    // CT-THR-005: cond false plus an arbitrary exception -> passthrough.
    @TestCase
    func testThr005CondFalsePassthrough() {
        var passthrough = false
        try {
            thrCondFalseThrows(false)
        } catch (e: ThrExB) {
            passthrough = true
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)
    }

    // CT-THR-006: declaration order decides; ExB does not satisfy ExA.
    @TestCase
    func testThr006DeclarationOrder() {
        var caught = false
        try {
            thrOrder(true)
        } catch (e: ContractCheckThrowsException) {
            caught = true
        } catch (e: ThrExB) {
            caught = false
        }
        @Expect(caught, true)
    }

    // CT-THR-007: a subclass instance satisfies the base-typed clause.
    @TestCase
    func testThr007SubtypeSatisfies() {
        var passthrough = false
        try {
            thrSubtype(true)
        } catch (e: ThrDerivedEx) {
            passthrough = true
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)
    }

    // CT-THR-008: generic clause type resolves per instantiation.
    @TestCase
    func testThr008GenericClauseType() {
        var passthrough = false
        try {
            thrGeneric<ThrExA>(true, ThrExA())
        } catch (e: ThrExA) {
            passthrough = true
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)

        var caught = false
        try {
            thrGeneric<ThrExA>(true, ThrExB())
        } catch (e: ContractCheckThrowsException) {
            caught = true
        } catch (e: Exception) {
            caught = false
        }
        @Expect(caught, true)
    }

    // CT-THR-009: parameter, global, member and auxiliary variables are all
    // valid condition references (local variables are the negative half).
    @TestCase
    func testThr009ConditionReferences() {
        // parameter reference
        var caught = false
        try {
            thrSilentReturn(true)
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)

        // global reference
        thrFlag = true
        caught = false
        try {
            thrGlobalCond()
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)

        thrFlag = false
        var failed = false
        try {
            thrGlobalCond()
        } catch (e: Exception) {
            failed = true
        }
        @Expect(failed, false)

        // member reference
        let m = ThrMember()
        var ok = true
        try {
            m.touch()
        } catch (e: Exception) {
            ok = false
        }
        @Expect(ok, true)
        m.limit = 11
        caught = false
        try {
            m.touch()
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)

        // auxiliary variable reference
        caught = false
        try {
            thrAuxCond()
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-THR-010: the verdict uses the entry snapshot of the condition.
    @TestCase
    func testThr010EntrySnapshot() {
        thrFlag = true
        var caught = false
        try {
            thrEntrySnapshot()
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)
        // The body did run and flipped the global.
        @Expect(thrFlag, false)
    }

    // CT-THR-012: exceptional exit checks `throws` only, never `ensures`.
    @TestCase
    func testThr012ThrowsOverEnsures() {
        var passthrough = false
        try {
            thrThrowsOverEnsures(true)
        } catch (e: ThrExA) {
            passthrough = true
        } catch (e: ContractCheckEnsuresException) {
            passthrough = false
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)
    }

    // CT-THR-013: business exception from condition evaluation passes through.
    @TestCase
    func testThr013CondBusinessException() {
        var passthrough = false
        try {
            thrCondThrows()
        } catch (e: IllegalArgumentException) {
            passthrough = true
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)
    }

    // CT-THR-014: naming a clause does not change its check.
    @TestCase
    func testThr014NamedClause() {
        var passthrough = false
        try {
            thrNamedThrow(true)
        } catch (e: ThrExA) {
            passthrough = true
        } catch (e: Exception) {
            passthrough = false
        }
        @Expect(passthrough, true)

        var caught = false
        try {
            thrNamedSilent(true)
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
