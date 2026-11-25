/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-013: interface contract generation: plain default members
// without any clause (member kept unchanged), default members under a type
// invariant (mut helper vs. class helper), static default members, interface
// static/instance abstract variables, default property contracts, and the
// property/method contract merge through `inherits from` (including the
// `[conforming]` variant).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

// Plain default members with no contract and no type invariant: the declaration
// is emitted unchanged.
@Contract
interface CovGenIfacePlain {
    func plainInt(x: Int64): Int64 {
        x + 1
    }

    func plainUnit(): Unit {}
}

// Type invariant + default members: the non-mut default member gets the class
// style helper, the `mut` default member gets the struct style (hoisted) helper,
// and the static default member is kept as-is.
@Contract [invariant value >= 0]
interface CovGenIfaceInv {
    prop value: Int64 {
        get() {
            1
        }
    }

    func nonMut(x: Int64): Int64 {
        x + 2
    }

    mut func mutDefault(x: Int64): Int64 {
        x + 3
    }

    static func staticDefault(x: Int64): Int64 {
        x * 2
    }
}

// Interface abstract variables are emitted as abstract properties; a static one
// becomes a static mutable property declaration on the interface.
@Contract [
    variable instanceVar: Int64 = 0
    static variable staticVar: Int64 = 7
]
interface CovGenIfaceVars {}

// A static interface variable inherited by an implementor materialises its
// storage on the implementor side.
@Contract [static variable total: Int64 = 5]
interface CovGenIfaceStaticHost {
    func readTotal(): Int64 {
        total
    }
}

@Contract [inherits from CovGenIfaceStaticHost]
class CovGenIfaceStaticImpl <: CovGenIfaceStaticHost {
    public init() {}
}

// Default property contract enforced through the type-level `@Contract []`.
@Contract []
interface CovGenIfacePropContract {
    @Contract [
        get ensures r: r > 0
    ]
    prop positive: Int64 {
        get() {
            -1
        }
    }
}

class CovGenIfacePropContractImpl <: CovGenIfacePropContract {}

// Property contract merge through `inherits from`: the parent property contract
// is found and the child contract does not conflict with it.
@Contract
interface CovGenIfacePropBase {
    @Contract [
        get ensures r: r >= 0
    ]
    prop num: Int64 {
        get() {
            1
        }
    }
}

@Contract [inherits from CovGenIfacePropBase]
interface CovGenIfacePropChild <: CovGenIfacePropBase {
    @Contract [
        get ensures r: r > 0
    ]
    prop num: Int64 {
        get() {
            2
        }
    }
}

// `[conforming]` parent: the redeclared method/property triggers the conforming
// pre/postcondition replay. Only `ensures` is added, which is legal.
@Contract
interface CovGenIfaceConfBase {
    @Contract [requires x > 0]
    func conf(x: Int64): Int64

    @Contract [get requires v > 0]
    prop confProp: Int64
}

@Contract [inherits from CovGenIfaceConfBase [conforming]]
interface CovGenIfaceConfChild <: CovGenIfaceConfBase {
    @Contract [ensures r: r > 0]
    func conf(x: Int64): Int64

    @Contract [get ensures r: r > 0]
    prop confProp: Int64
}

class CovGenIfacePlainImpl <: CovGenIfacePlain {
    public init() {}
    public func plainInt(x: Int64): Int64 {
        x + 1
    }
    public func plainUnit(): Unit {}
}

class CovGenIfaceInvImpl <: CovGenIfaceInv {
    public init() {}
}

@Test
class Test {
    @TestCase
    func testPlainDefaultMembers() {
        let impl = CovGenIfacePlainImpl()
        @Expect(impl.plainInt(1), 2)
        impl.plainUnit()
    }

    @TestCase
    func testInvariantDefaultMembers() {
        let impl = CovGenIfaceInvImpl()
        @Expect(impl.nonMut(1), 3)
        @Expect(impl.mutDefault(1), 4)
        @Expect(impl.value, 1)
    }

    @TestCase
    func testStaticInterfaceVariable() {
        let impl = CovGenIfaceStaticImpl()
        @Expect(impl.readTotal(), 5)
    }

    @TestCase
    func testDefaultPropertyContract() {
        let impl = CovGenIfacePropContractImpl()
        var caught = false
        try {
            let _ = impl.positive
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    @TestCase
    func testConformingInterface() {
        // The conforming interfaces only need to compile; no concrete implementor
        // is required to exercise the contract replay.
        @Expect(CovGenIfacePropChildImpl().num, 2)
    }
}

class CovGenIfacePropChildImpl <: CovGenIfacePropChild {}
