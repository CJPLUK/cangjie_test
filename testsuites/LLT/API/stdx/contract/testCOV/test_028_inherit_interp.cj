/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-028: inheritance mechanics that exercise the renaming of
// parent parameters inside string interpolation, a parent contract `variable`
// without an initializer, member-level `inherits` clauses replayed one level
// down, type-argument substitution in conditions, and instantiation of a
// named inherited invariant from a generic interface.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract []
open class InterpBase {
    public init() {}

    @Contract [ requires "${n}".size > 0 ]
    public open func echo(n: String): String {
        n
    }
}

@Contract [ inherits from InterpBase ]
class InterpChild <: InterpBase {
    public init() {}

    public override func echo(x: String): String {
        x
    }
}

@Contract []
open class VarNoInitBase {
    public init() {}

    @Contract [
        variable acc: Int64
        ensures r: r == x
    ]
    public open func withVar(x: Int64): Int64 {
        @ghost ( acc = x )
        x
    }
}

@Contract [ inherits from VarNoInitBase ]
class VarNoInitChild <: VarNoInitBase {
    public init() {}

    public override func withVar(y: Int64): Int64 {
        y
    }
}

@Contract []
interface Level0 {
    @Contract [ requires [deep_req] x > 0 ]
    func deep(x: Int64): Int64
}

@Contract []
open class Level1 <: Level0 {
    public init() {}

    @Contract [ inherits requires Level0.deep_req ]
    public open func deep(x: Int64): Int64 {
        x
    }
}

@Contract [ inherits from Level1 ]
class Level2 <: Level1 {
    public init() {}

    public func deep(x: Int64): Int64 {
        x * 2
    }
}

@Contract []
open class GenBase2<T> {
    public init() {}

    @Contract [ requires v is T ]
    public open func chk(v: Any): Bool {
        v is T
    }
}

@Contract [ inherits from GenBase2<String> ]
class GenChild2 <: GenBase2<String> {
    public init() {}

    public override func chk(v: Any): Bool {
        v is String
    }
}

@Contract [
    variable cnt: Int64 = 0
    invariant [found] cnt >= 0
]
interface GenInvI<T> {
    func bump(x: T): Unit
}

@Contract [
    inherits from GenInvI<Int64>
    inherits invariant GenInvI<Int64>.found
]
class GenInvC <: GenInvI<Int64> {
    public init() {}
    public func bump(x: Int64): Unit {
        ()
    }
}

@Test
class Test {
    @TestCase
    func testInterpInherit() {
        let c = InterpChild()
        @Expect(c.echo("hi"), "hi")
    }

    @TestCase
    func testVarNoInit() {
        let c = VarNoInitChild()
        @Expect(c.withVar(5), 5)
    }

    @TestCase
    func testLevel2() {
        let c = Level2()
        @Expect(c.deep(3), 6)
    }

    @TestCase
    func testGenericSubstitution() {
        let c = GenChild2()
        @Expect(c.chk("s"), true)
    }

    @TestCase
    func testNamedInvariantInstantiation() {
        let c = GenInvC()
        c.bump(1)
    }
}
