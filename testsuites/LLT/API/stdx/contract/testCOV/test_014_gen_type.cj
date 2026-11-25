/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-014: class/struct type contract generation: class property
// contract inheritance through `inherits from`, conforming property replay,
// abstract functions and properties, open-class primary constructors, protected
// and static member condition checkers, and multi-constraint `where` clauses.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

// Property contract inherited from a parent class and redeclared by an override.
@Contract
open class CovGenTypeBase {
    public init() {}

    @Contract [
        get ensures r: r >= 0
    ]
    public open prop base: Int64 {
        get() {
            1
        }
    }
}

@Contract [inherits from CovGenTypeBase]
class CovGenTypeChild <: CovGenTypeBase {
    public init() {
        super()
    }

    @Contract [
        get ensures r: r > 0
    ]
    public override prop base: Int64 {
        get() {
            2
        }
    }
}

// Conforming interface implemented by a class: the override adds only `ensures`.
@Contract
interface CovGenTypeConfIface {
    @Contract [requires x > 0]
    func conf(x: Int64): Int64

    @Contract [get ensures r: r > 0]
    prop confProp: Int64
}

@Contract [inherits from CovGenTypeConfIface [conforming]]
class CovGenTypeConfImpl <: CovGenTypeConfIface {
    public init() {}

    @Contract [ensures r: r > 0]
    public func conf(x: Int64): Int64 {
        x
    }

    @Contract [get ensures r: r > 0]
    public prop confProp: Int64 {
        get() {
            1
        }
    }
}

// Abstract members: body-less functions/properties are kept unchanged.
@Contract
abstract class CovGenTypeAbstract {
    public init() {}

    @Contract [requires x >= 0]
    public func abstractFunc(x: Int64): Int64

    public prop abstractProp: Int64
}

// Invariant-only wrapping of a body-less property is skipped.
@Contract [invariant this.amount >= 0]
abstract class CovGenTypeAbstractInv {
    public init() {}

    public prop amount: Int64
}

// Open class with a primary constructor: the constructor is left to the
// compiler-generated wrapper.
@Contract [invariant value >= 0]
open class CovGenTypeOpen {
    CovGenTypeOpen(public let value: Int64) {}
}

// Protected / static / protected-static member contracts exercise the visibility
// and static condition-checker branches.
@Contract
class CovGenTypeVisibility {
    public init() {}

    @Contract [requires n >= 0]
    protected func prot(n: Int64): Int64 {
        n
    }

    @Contract [requires n >= 0]
    static func stat(n: Int64): Int64 {
        n
    }

    @Contract [requires n >= 0]
    protected static func protStat(n: Int64): Int64 {
        n
    }

    public func callProt(n: Int64): Int64 {
        prot(n)
    }

    public static func callStat(n: Int64): Int64 {
        stat(n)
    }

    public static func callProtStat(n: Int64): Int64 {
        protStat(n)
    }
}

// Generic member with more than one `where` constraint.
@Contract
class CovGenTypeGeneric {
    public init() {}

    @Contract [requires n >= 0]
    public func pair<T, U>(n: Int64, t: T, u: U): Int64 where T <: ToString, U <: Any {
        n
    }
}

// Static variable owned by an open class (protected storage) and by an
// interface implementor (public storage).
@Contract [static variable ownCounter: Int64 = 0]
open class CovGenTypeStaticOwner {
    public init() {}
}

@Contract [static variable sharedCounter: Int64 = 9]
interface CovGenTypeStaticIface {
    func readShared(): Int64 {
        sharedCounter
    }
}

@Contract [inherits from CovGenTypeStaticIface]
class CovGenTypeStaticImpl <: CovGenTypeStaticIface {
    public init() {}
}

@Test
class Test {
    @TestCase
    func testPropertyInheritance() {
        @Expect(CovGenTypeChild().base, 2)
    }

    @TestCase
    func testConformingClass() {
        let impl = CovGenTypeConfImpl()
        @Expect(impl.conf(3), 3)
        @Expect(impl.confProp, 1)
        var caught = false
        try {
            impl.conf(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    @TestCase
    func testOpenPrimaryConstructor() {
        @Expect(CovGenTypeOpen(4).value, 4)
    }

    @TestCase
    func testVisibilityCheckers() {
        let v = CovGenTypeVisibility()
        @Expect(v.callProt(2), 2)
        @Expect(CovGenTypeVisibility.callStat(2), 2)
        @Expect(CovGenTypeVisibility.callProtStat(2), 2)
    }

    @TestCase
    func testGenericMember() {
        @Expect(CovGenTypeGeneric().pair<Int64, Int64>(5, 1, 2), 5)
    }

    @TestCase
    func testStaticVariables() {
        @Expect(CovGenTypeStaticImpl().readShared(), 9)
        @Expect(CovGenTypeStaticOwner.ownCounter, 0)
    }
}
