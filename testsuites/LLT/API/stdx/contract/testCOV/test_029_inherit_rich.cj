/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-029: property-level contract inheritance (selective and renamed),
// rich member clause adaptation (labels, @pre, throws-if, function-level
// variables, string interpolation), visibility/static invariants inherited
// through `inherits from`, and constructor invariant injection into structured
// constructor bodies (if/while/do-while/for/match/try, super calls, locals).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// ASSERT: scan-not core dumped
import stdx.contract.macros.*
import std.unittest.*
import std.unittest.testmacro.*

// ---------------------------------------------------------------------------
// Property contracts inherited selectively by an implementing class.
// ---------------------------------------------------------------------------

@Contract [
    variable scaleVar: Int64 = 1
]
interface CovPropParent {
    @Contract [
        get {
            requires [gpos] scaleVar > 0
            ensures [gpost] r: r >= 0
        }
        set {
            requires [spos] value >= 0
            ensures [spost] value * scaleVar >= 0
        }
    ]
    mut prop amount: Int64
}

// Full inheritance plus an extra plain clause in the getter accessor.
@Contract [
    inherits from CovPropParent
]
class CovPropFull <: CovPropParent {
    private var store: Int64 = 0

    @Contract [
        get {
            requires store >= -1000
        }
    ]
    public mut prop amount: Int64 {
        get() {
            store
        }
        set(v) {
            store = v
        }
    }

    public init() {}
}

// Selective inheritance only (no `inherits from`), with a renamed clause.
@Contract []
class CovPropSel <: CovPropParent {
    private var store: Int64 = 0

    @Contract [
        get {
            inherits ensures gpostRen = CovPropParent.gpost
        }
        set {
            requires store >= -5
            inherits ensures CovPropParent.spost
        }
    ]
    public mut prop amount: Int64 {
        get() {
            store
        }
        set(v) {
            store = v
        }
    }

    public init() {}
}

// ---------------------------------------------------------------------------
// Rich parent: labels, @pre, throws-if, function-level variable,
// string interpolation, visibility/static invariants.
// ---------------------------------------------------------------------------

@Contract [
    variable budget: Int64 = 5
    on_public invariant [pubInv] budget > 0
    on_protected invariant [protInv] budget >= 0
    on_private invariant [privInv] budget >= 0
    static invariant [stInv] CovRichParent.marker() > 0
]
open class CovRichParent {
    public var acc: Int64 = 0

    public static func marker(): Int64 {
        7
    }

    public init() {}

    @Contract [
        variable extra: Int64 = 1
        requires [rpos] x > 0
        ensures [epost] r: r >= x + extra
        throws [tbad] IllegalArgumentException if x < -100
    ]
    public open func scale(x: Int64): Int64 {
        x + extra
    }

    @Contract [
        ensures [lbl] r: "value=${x}" == r
    ]
    public open func tag(x: Int64): String {
        "value=${x}"
    }

    @Contract [
        ensures [grew] $pre(acc) <= acc
    ]
    public open func bump(n: Int64): Int64 {
        acc += n
        acc
    }

    protected func protPeek(): Int64 {
        budget
    }

    private func privPeek(): Int64 {
        budget
    }

    public func touch(): Int64 {
        privPeek() + protPeek()
    }
}

// Full inheritance: adapts every clause kind, renames parameters positionally
// and rewrites string interpolation.
@Contract [
    inherits from CovRichParent
    inherits invariant renamedProt = CovRichParent.protInv
]
class CovRichChild <: CovRichParent {
    public init() {}

    public override func scale(y: Int64): Int64 {
        y + extra
    }

    public override func tag(z: Int64): String {
        "value=${z}"
    }

    public override func bump(m: Int64): Int64 {
        super.bump(m)
    }
}

// Selective inheritance with a renamed clause on top of full inheritance of a
// sibling member (the parent has a function-level variable with an initializer
// whose name matches the child parameter, so rename capture bails out).
@Contract [
    variable baseVar: Int64 = 1
]
open class CovVarParent {
    public init() {}

    @Contract [
        variable tmp: Int64 = 1
        requires q > 0
        ensures r: r >= q
    ]
    public open func compute(q: Int64): Int64 {
        q + tmp
    }
}

@Contract [
    inherits from CovVarParent
]
class CovVarChild <: CovVarParent {
    public init() {}

    public override func compute(tmp: Int64): Int64 {
        tmp
    }
}

// ---------------------------------------------------------------------------
// Constructors with invariants: structured bodies and super calls.
// ---------------------------------------------------------------------------

open class CovCtorBase {
    public var seed: Int64 = 0

    public init() {}
}

@Contract [
    invariant [shapeInv] value >= 0
]
class CovCtorShapes <: CovCtorBase {
    public var value: Int64 = 0

    @Contract [
        requires n >= 0
        ensures value >= 0
    ]
    public init(n: Int64) {
        super()
        let local = 1
        var i = 0
        while (i < n) {
            i += 1
        }
        for (x in [1, 2, 3]) {
            value += x
        }
        do {
            value += 0
        } while (value < 0)
        match (n) {
            case 0 => value += local
            case _ => value += 0
        }
        try {
            value += 0
        } catch (e: Exception) {
            value += -1
        }
        if (n > 100) {
        } else if (n > 50) {
            value += 1
        } else {
            value += 0
        }
    }

    @Contract []
    public init() {
        super()
        value = 42
    }
}

// An auxiliary variable without an initializer must be assigned in a
// constructor @ghost block; the primary constructor branch records it.
@Contract [
    invariant [tokInv] value >= 0
]
class CovAuxCtor {
    public var value: Int64 = 0

    @Contract [
        ensures value == 1
    ]
    public init() {
        value = 1
    }
}

// A primary constructor (`Type(params) { ... }` inside the class body) with an
// auxiliary variable that has no initializer: the primary-constructor branch of
// the unassigned-variable scan records the `@ghost` assignment.
@Contract [
    variable tok: Int64
    invariant [tokInv2] tok >= 0
]
class CovPrimaryAux {
    CovPrimaryAux(public let x: Int64) {
        @ghost(
            tok = x
        )
    }

    public func peek(): Int64 {
        x
    }
}

@Test
class CovInheritRichTest {
    @TestCase
    func propFull() {
        let p = CovPropFull()
        p.amount = 5
        @Expect(p.amount, 5)
    }

    @TestCase
    func propSelective() {
        let p = CovPropSel()
        p.amount = 3
        @Expect(p.amount, 3)
    }

    @TestCase
    func richChild() {
        let c = CovRichChild()
        @Expect(c.scale(2), 3)
        @Expect(c.tag(9), "value=9")
        @Expect(c.bump(2) >= 2, true)
        @Expect(c.touch(), 10)
    }

    @TestCase
    func varChild() {
        let c = CovVarChild()
        @Expect(c.compute(4) >= 0, true)
    }

    @TestCase
    func ctorShapes() {
        let a = CovCtorShapes(2)
        @Expect(a.value >= 0, true)
        let b = CovCtorShapes()
        @Expect(b.value, 42)
    }

    @TestCase
    func auxCtor() {
        let c = CovAuxCtor()
        @Expect(c.value, 1)
    }

    @TestCase
    func primaryAux() {
        let c = CovPrimaryAux(4)
        @Expect(c.peek(), 4)
    }
}
