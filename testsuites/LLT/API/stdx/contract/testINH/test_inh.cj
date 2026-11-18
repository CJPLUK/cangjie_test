/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// CT-INH runtime cases: 001~008, 010~014, 018~019, 023~029, 031~035, 037~039,
// 042.
// CT-INH-030 (checks off) is covered by the compile-time `contract_check` dual
// build (design §3.5 / R8) and has no runtime case.
// CT-INH-020 / CT-INH-021 are already covered by
// testNEG/test_neg_022_inherits_unknown.cj and
// testNEG/test_neg_023_inherits_non_direct.cj.
// Negative cases live next to this file:
//   009 conforming requires, 015/016 variable rename (not supported by design
//   v2), 017 duplicate renamed invariant, 022 duplicate same-label invariants
//   from two parents (no diagnostic under design v2, pinned as a compile
//   positive control), 036 same-label conflict, 040 same-kind name conflict
//   from two unrelated parents with identical text, 041 function-level
//   `inherits` referencing a different-signature overload.
// Documented deviations (implementation ≠ DT expectation, pinned as runtime
// cases with the code evidence in the comments):
//   010 conforming weaker `ensures` is not diagnosed (only `requires` is
//       checked by reportConformingRequires in generate/interface.cj),
//   011 conforming wider `throws` is not diagnosed (same reason).

import stdx.contract.macros.*

var inhTrace: String = ""

func inhTick(tag: String): Bool {
    inhTrace += tag
    true
}

func inhReset(): Unit {
    inhTrace = ""
}

class InhExA <: Exception {
    init(m: String) {
        super(m)
    }
}

class InhExB <: Exception {
    init(m: String) {
        super(m)
    }
}

// CT-INH-001: subclass does not override, inherited method keeps parent contract.
@Contract
open class InhBase001 {
    public var amount: Int64 = 0

    public init() {}

    @Contract[
        requires x > 0
        ensures amount == $pre(amount) + x
    ]
    public func accumulate(x: Int64): Unit {
        amount += x
    }
}

@Contract
class InhSub001 <: InhBase001 {
    public init() {
        super()
    }
}

// CT-INH-002: `inherits from` makes the subclass inherit the parent contract, which is
// then enforced on the override (contracts are not inherited by default, design v2 §3.4).
@Contract
open class InhBase002 {
    public var total: Int64 = 0

    public init() {}

    @Contract[
        requires d >= 0
        ensures total == $pre(total) + d
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}

@Contract[
    inherits from InhBase002
]
class InhSub002 <: InhBase002 {
    public init() {
        super()
    }

    public override func add(d: Int64): Unit {
        total += d * 2
    }
}

// CT-INH-003: subclass adds `requires`, parent and child conditions are merged.
@Contract
open class InhBase003 {
    public init() {}

    @Contract[
        requires x > 0
    ]
    public open func take(x: Int64): Int64 {
        x
    }
}

@Contract[
    inherits from InhBase003
]
class InhSub003 <: InhBase003 {
    public init() {
        super()
    }

    @Contract[
        requires x < 100
    ]
    public override func take(x: Int64): Int64 {
        x
    }
}

// CT-INH-004: subclass adds `ensures`, both postconditions are checked.
@Contract
open class InhBase004 {
    public init() {}

    @Contract[
        ensures r: r > 0
    ]
    public open func positive(): Int64 {
        1
    }

    @Contract[
        ensures r: r < 10
    ]
    public open func small(): Int64 {
        1
    }
}

@Contract[
    inherits from InhBase004
]
class InhSub004 <: InhBase004 {
    public init() {
        super()
    }

    @Contract[
        ensures r: r < 10
    ]
    public override func positive(): Int64 {
        20
    }

    @Contract[
        ensures r: r > 0
    ]
    public override func small(): Int64 {
        -5
    }
}

// CT-INH-005: subclass adds `throws`, conditions of parent and child are merged.
@Contract
open class InhBase005 {
    public init() {}

    @Contract[
        throws InhExA if x < 0
    ]
    public open func risky(x: Int64): Unit {
        if (x < 0) {
            throw InhExA("neg")
        }
    }
}

@Contract[
    inherits from InhBase005
]
class InhSub005 <: InhBase005 {
    public init() {
        super()
    }

    @Contract[
        throws InhExB if x > 100
    ]
    public override func risky(x: Int64): Unit {
        if (x < 0) {
            throw InhExA("neg")
        }
        if (x > 100) {
            throw InhExB("big")
        }
    }
}

// CT-INH-006: explicit `inherits from`.
@Contract
open class InhBase006 {
    public init() {}

    @Contract[
        requires x > 0
    ]
    public open func check(x: Int64): Unit {}
}

@Contract[
    inherits from InhBase006
]
class InhSub006 <: InhBase006 {
    public init() {
        super()
    }
}

// CT-INH-007: no `inherits from`, so the parent contract is not inherited by the
// override and no check runs (contracts are not inherited by default, design v2 §3.4).
@Contract
open class InhBase007 {
    public init() {}

    @Contract[
        requires x > 0
    ]
    public open func check(x: Int64): Unit {}
}

@Contract
class InhSub007 <: InhBase007 {
    public init() {
        super()
    }

    public override func check(x: Int64): Unit {}
}

// CT-INH-008: `[conforming]` with a behaviour-preserving subclass compiles and
// keeps the runtime checks.
@Contract
open class InhBase008 {
    public init() {}

    @Contract[
        requires x > 0
    ]
    public open func run(x: Int64): Int64 {
        x
    }
}

@Contract[
    inherits from InhBase008 [conforming]
]
class InhSub008 <: InhBase008 {
    public init() {
        super()
    }

    @Contract[
        ensures r: r > 0
    ]
    public override func run(x: Int64): Int64 {
        x + 1
    }
}

// CT-INH-010 (documented deviation): a weaker `ensures` on a `[conforming]`
// override is not diagnosed; only added `requires` is (CT-INH-009). The
// inherited parent postcondition is still enforced, so behaviour does not
// silently weaken.
@Contract
open class InhBase010 {
    public init() {}

    @Contract[
        ensures x > 0
    ]
    public open func pick(x: Int64): Int64 {
        x
    }
}

@Contract[
    inherits from InhBase010 [conforming]
]
class InhSub010 <: InhBase010 {
    public init() {
        super()
    }

    @Contract[
        ensures x >= 0
    ]
    public override func pick(x: Int64): Int64 {
        x
    }
}

// CT-INH-011 (documented deviation): a wider `throws` on a `[conforming]`
// override is not diagnosed. Both merged clauses behave per the selection
// rule (first clause whose condition holds decides the expected type).
@Contract
open class InhBase011 {
    public init() {}

    @Contract[
        throws InhExA if flag
    ]
    public open func fire(flag: Bool): Unit {
        if (flag) {
            throw InhExA("a")
        }
    }
}

@Contract[
    inherits from InhBase011 [conforming]
]
class InhSub011 <: InhBase011 {
    public init() {
        super()
    }

    @Contract[
        throws InhExB if !flag
    ]
    public override func fire(flag: Bool): Unit {
        if (flag) {
            throw InhExA("a")
        }
        throw InhExB("b")
    }
}

// CT-INH-012 / CT-INH-014: class-level auxiliary variables are always inherited
// (design v2 §3.4.1); the parent invariant is only checked when explicitly inherited.
@Contract[
    variable selCount: Int64 = 5
    invariant [SelInv] selCount > 0
]
open class InhBaseSel {
    public init() {}
}

@Contract[
    invariant [ChildInv] selCount > 0
]
class InhSubSelVar <: InhBaseSel {
    public init() {
        super()
    }

    public func bump(delta: Int64): Unit {
        selCount = selCount + delta
    }
}

@Contract
class InhSubSelVarOnly <: InhBaseSel {
    public init() {
        super()
    }

    public func bump(delta: Int64): Unit {
        selCount = selCount + delta
    }
}

// CT-INH-013: selective `invariant` inheritance, only SelInv is checked.
@Contract[
    inherits invariant InhBaseSel.SelInv
]
class InhSubSelInv <: InhBaseSel {
    public init() {
        super()
    }

    public func bump(delta: Int64): Unit {
        selCount = selCount + delta
    }
}

// CT-INH-018 / CT-INH-019: no inheritance versus re-inheriting an invariant selectively.
@Contract
class InhSubRevoked <: InhBaseSel {
    public init() {
        super()
    }

    public func bump(delta: Int64): Unit {
        selCount = selCount + delta
    }
}

@Contract[
    inherits invariant InhBaseSel.SelInv
]
class InhSubReInherit <: InhBaseSel {
    public init() {
        super()
    }

    public func bump(delta: Int64): Unit {
        selCount = selCount + delta
    }
}

// CT-INH-023 / CT-INH-024: diamond through interfaces.
@Contract[
    invariant [RootInv] inhTick("r")
]
interface InhRoot {
    public func run(): Unit
}

@Contract[
    inherits from InhRoot
    invariant [LeftInv] inhTick("l")
]
interface InhLeft <: InhRoot {
    public func run(): Unit
}

@Contract[
    inherits from InhRoot
    invariant [RightInv] inhTick("g")
]
interface InhRight <: InhRoot {
    public func run(): Unit
}

@Contract[
    inherits from InhLeft
    inherits from InhRight
]
class InhDiamond <: InhLeft & InhRight {
    public init() {
        inhReset()
    }

    public func run(): Unit {
        inhTrace += "|"
    }
}

@Contract[
    inherits from InhRight
    inherits from InhLeft
]
class InhDiamondRev <: InhRight & InhLeft {
    public init() {
        inhReset()
    }

    public func run(): Unit {
        inhTrace += "|"
    }
}

// CT-INH-025 / CT-INH-026: dynamic dispatch.
@Contract
open class InhDynBase {
    public init() {}

    @Contract[
        requires inhTick("p") && x > 0
    ]
    public open func virt(x: Int64): Int64 {
        x
    }

    @Contract[
        requires inhTick("f") && x > 0
    ]
    public func fixed(x: Int64): Int64 {
        x
    }
}

@Contract[
    inherits from InhDynBase
]
class InhDynChild <: InhDynBase {
    public init() {
        super()
    }

    @Contract[
        requires inhTick("c") && x > 10
    ]
    public override func virt(x: Int64): Int64 {
        x + 1
    }
}

// CT-INH-027: contracts on an interface default method are checked when an
// implementor inherits the default body.
@Contract
interface InhDefaultCalc {
    @Contract[
        requires x > 0
        ensures r: r > 0
    ]
    public func calc(x: Int64): Int64 {
        x
    }
}

@Contract
class InhDefaultUser <: InhDefaultCalc {
    public init() {}
}

// CT-INH-028: override of an interface default method inherits its contract.
@Contract[
    inherits from InhDefaultCalc
]
class InhDefaultOverride <: InhDefaultCalc {
    public init() {}

    public override func calc(x: Int64): Int64 {
        x + 1
    }
}

// CT-INH-029: generic parent instantiated with Int64 and String.
@Contract
open class InhGenBase<T> where T <: Equatable<T> {
    public let value: T

    public init(v: T) {
        value = v
    }

    @Contract[
        ensures r: r == value
    ]
    public open func get(): T {
        value
    }
}

@Contract
class InhGenInt <: InhGenBase<Int64> {
    public init(v: Int64) {
        super(v)
    }
}

@Contract
class InhGenStr <: InhGenBase<String> {
    public init(v: String) {
        super(v)
    }
}

// CT-INH-031: two parents declare the same invariant label, resolved by rename.
@Contract[
    invariant [I1] inhTick("b")
]
interface InhRenB {
    public func run(): Unit
}

@Contract[
    invariant [I1] inhTick("c")
]
interface InhRenC {
    public func run(): Unit
}

@Contract[
    inherits invariant I2 = InhRenB.I1
    inherits invariant I3 = InhRenC.I1
]
class InhRenBoth <: InhRenB & InhRenC {
    public init() {
        inhReset()
    }

    public func run(): Unit {
        inhTrace += "|"
    }
}

// CT-INH-032: mixed path, A.I1 is inherited selectively by B and fully by C.
@Contract[
    invariant [I1] inhTick("a")
]
interface InhMixA {
    public func act(): Unit
}

@Contract[
    inherits invariant InhMixA.I1
]
interface InhMixB <: InhMixA {
    public func act(): Unit
}

@Contract[
    inherits from InhMixA
]
interface InhMixC <: InhMixA {
    public func act(): Unit
}

@Contract[
    inherits from InhMixB
    inherits from InhMixC
]
class InhMixD <: InhMixB & InhMixC {
    public init() {
        inhReset()
    }

    public func act(): Unit {
        inhTrace += "|"
    }
}

// CT-INH-033: multi-level diamond A <- B <- C, A <- D <- E, F <: C & E.
@Contract[
    invariant [IA] inhTick("A")
]
interface InhLayA {
    public func go(): Unit
}

@Contract[
    inherits from InhLayA
    invariant [IB] inhTick("B")
]
interface InhLayB <: InhLayA {
    public func go(): Unit
}

@Contract[
    inherits from InhLayB
    invariant [IC] inhTick("C")
]
interface InhLayC <: InhLayB {
    public func go(): Unit
}

@Contract[
    inherits from InhLayA
    invariant [ID] inhTick("D")
]
interface InhLayD <: InhLayA {
    public func go(): Unit
}

@Contract[
    inherits from InhLayD
    invariant [IE] inhTick("E")
]
interface InhLayE <: InhLayD {
    public func go(): Unit
}

@Contract[
    inherits from InhLayC
    inherits from InhLayE
    invariant [IF] inhTick("F")
]
class InhLayF <: InhLayC & InhLayE {
    public init() {
        inhReset()
    }

    public func go(): Unit {
        inhTrace += "|"
    }
}

// CT-INH-034: three-generation chain accumulating contracts.
@Contract
open class InhThreeA {
    public init() {}

    @Contract[
        requires [aReq] x > 0
        ensures [aEns] x != 0
    ]
    public open func step(x: Int64): Int64 {
        x
    }
}

@Contract[
    inherits from InhThreeA
]
open class InhThreeB <: InhThreeA {
    public init() {
        super()
    }

    @Contract[
        requires x < 1000
        ensures r: r < 1000
    ]
    public open override func step(x: Int64): Int64 {
        x + 1
    }
}

@Contract[
    inherits from InhThreeB
]
class InhThreeC <: InhThreeB {
    public init() {
        super()
    }

    @Contract[
        requires x != 50
        ensures r: r != 50
    ]
    public override func step(x: Int64): Int64 {
        x + 2
    }
}

// CT-INH-035: an override may inherit the parent contract names instead of redeclaring
// them; redeclaring a same-kind name is rejected (see CT-INH-036, design v2 §3.2.5).
@Contract
open class InhSameBase {
    public init() {}

    @Contract[
        requires [pos] x > 0
        ensures [kept] x > 0
    ]
    public open func work(x: Int64): Int64 {
        x
    }
}

@Contract
class InhSameSub <: InhSameBase {
    public init() {
        super()
    }

    @Contract[
        inherits requires InhSameBase.pos
        inherits ensures InhSameBase.kept
    ]
    public override func work(x: Int64): Int64 {
        x + 1
    }
}

// CT-INH-037: struct implements a contract-bearing interface.
@Contract
interface InhStructIface {
    @Contract[
        requires x > 0
        ensures r: r > 0
    ]
    public func apply(x: Int64): Int64
}

@Contract[
    inherits from InhStructIface
]
struct InhStructImpl <: InhStructIface {
    public func apply(x: Int64): Int64 {
        x + 1
    }
}

// CT-INH-038: an interface that redeclares an inherited member keeps the
// ancestor's contract alongside its own.
@Contract
interface InhReA {
    @Contract[
        requires x > 0
    ]
    public func take(x: Int64): Int64
}

@Contract[
    inherits from InhReA
]
interface InhReB <: InhReA {
    @Contract[
        ensures r: r == x
    ]
    public func take(x: Int64): Int64
}

@Contract[
    inherits from InhReB
]
class InhReImpl <: InhReB {
    public init() {}

    public func take(x: Int64): Int64 {
        x
    }
}

// CT-INH-039: a renamed inherited invariant stays distinct from the original
// and can be renamed again in a further generation.
@Contract[
    invariant [I1] inhTick("d")
]
interface InhRenChainA {
    public func run(): Unit
}

@Contract[
    inherits from InhRenChainA
    inherits invariant X = InhRenChainA.I1
]
interface InhRenChainB <: InhRenChainA {
    public func run(): Unit
}

@Contract[
    inherits from InhRenChainB
    inherits invariant Y = InhRenChainB.X
]
class InhRenChainC <: InhRenChainB {
    public init() {
        inhReset()
    }

    public func run(): Unit {
        inhTrace += "|"
    }
}

@Contract[
    inherits from InhRenChainB
]
class InhRenChainSink <: InhRenChainB {
    public init() {
        inhReset()
    }

    public func run(): Unit {
        inhTrace += "|"
    }
}

// CT-INH-042: `[conforming]` restricts only the members of the conforming
// parent; an override of a non-conforming parent may still strengthen its
// precondition.
@Contract
interface InhConfA {
    @Contract[
        requires x > 0
    ]
    public func a(x: Int64): Int64
}

@Contract
interface InhConfB {
    public func b(x: Int64): Int64
}

@Contract[
    inherits from InhConfA [conforming]
    inherits from InhConfB
]
class InhConfImpl <: InhConfA & InhConfB {
    public init() {}

    public func a(x: Int64): Int64 {
        x
    }

    @Contract[
        requires x > 10
    ]
    public func b(x: Int64): Int64 {
        x
    }
}

// CT-INH-044: a generic interface's variable/invariant/default member are
// inherited per type argument (`inherits from InhGenericI<Int64>`); the
// inherited invariant is checkpointed on the implementation's own members.
@Contract[
    variable touched: Int64 = 0
    invariant [G44] touched >= 0
]
interface InhGenericI<T> {
    func touch(n: T): Int64 {
        @ghost(
            touched = touched + 1
        )
        1
    }
}

@Contract[
    inherits from InhGenericI<Int64>
]
class InhGenericImpl <: InhGenericI<Int64> {
    public init() {}

    public func touch(n: Int64): Int64 {
        1
    }

    public func corrupt(): Unit {
        @ghost(
            touched = -1
        )
    }
}

@Test
class Test {
    // CT-INH-001
    @TestCase
    func testInh001InheritedMethod() {
        let sub = InhSub001()
        sub.accumulate(2)
        @Expect(sub.amount, 2)

        var caught = false
        try {
            sub.accumulate(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-002
    @TestCase
    func testInh002OverrideInheritsContract() {
        let sub = InhSub002()
        var requiresCaught = false
        try {
            sub.add(-1)
        } catch (e: ContractCheckRequiresException) {
            requiresCaught = true
        }
        @Expect(requiresCaught, true)

        var ensuresCaught = false
        try {
            sub.add(3)
        } catch (e: ContractCheckEnsuresException) {
            ensuresCaught = true
        }
        @Expect(ensuresCaught, true)
    }

    // CT-INH-003
    @TestCase
    func testInh003MergedRequires() {
        let sub = InhSub003()
        @Expect(sub.take(5), 5)

        var parentViolation = false
        try {
            sub.take(-1)
        } catch (e: ContractCheckRequiresException) {
            parentViolation = true
        }
        @Expect(parentViolation, true)

        var childViolation = false
        try {
            sub.take(200)
        } catch (e: ContractCheckRequiresException) {
            childViolation = true
        }
        @Expect(childViolation, true)
    }

    // CT-INH-004
    @TestCase
    func testInh004MergedEnsures() {
        let sub = InhSub004()
        var childViolation = false
        try {
            sub.positive()
        } catch (e: ContractCheckEnsuresException) {
            childViolation = true
        }
        @Expect(childViolation, true)

        var parentViolation = false
        try {
            sub.small()
        } catch (e: ContractCheckEnsuresException) {
            parentViolation = true
        }
        @Expect(parentViolation, true)
    }

    // CT-INH-005
    @TestCase
    func testInh005MergedThrows() {
        let sub = InhSub005()
        var sawA = false
        try {
            sub.risky(-1)
        } catch (e: InhExA) {
            sawA = true
        } catch (e: Exception) {
        }
        @Expect(sawA, true)

        var sawB = false
        try {
            sub.risky(200)
        } catch (e: InhExB) {
            sawB = true
        } catch (e: Exception) {
        }
        @Expect(sawB, true)

        // The merged clauses accept both declared exception kinds: neither the
        // legal x == 50 path nor the two declared throws violate the contract.
        var contractError = false
        try {
            sub.risky(50)
        } catch (e: ContractCheckThrowsException) {
            contractError = true
        }
        try {
            sub.risky(-1)
        } catch (e: ContractCheckThrowsException) {
            contractError = true
        } catch (e: Exception) {
        }
        try {
            sub.risky(200)
        } catch (e: ContractCheckThrowsException) {
            contractError = true
        } catch (e: Exception) {
        }
        @Expect(contractError, false)
    }

    // CT-INH-006
    @TestCase
    func testInh006ExplicitInherits() {
        let sub = InhSub006()
        var caught = false
        try {
            sub.check(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-007
    @TestCase
    func testInh007NoImplicitInheritance() {
        let sub = InhSub007()
        // A 0 argument violates the parent precondition, but the override does not
        // inherit it, so the call is not rejected.
        sub.check(0)
    }

    // CT-INH-008
    @TestCase
    func testInh008ConformingValid() {
        let sub = InhSub008()
        @Expect(sub.run(2), 3)

        var caught = false
        try {
            sub.run(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-010 (documented deviation)
    @TestCase
    func testInh010ConformingWeakerEnsures() {
        let sub = InhSub010()
        @Expect(sub.pick(1), 1)

        var caught = false
        try {
            sub.pick(-1)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-011 (documented deviation)
    @TestCase
    func testInh011ConformingWiderThrows() {
        let sub = InhSub011()
        var sawA = false
        try {
            sub.fire(true)
        } catch (e: InhExA) {
            sawA = true
        } catch (e: Exception) {
        }
        @Expect(sawA, true)

        var sawB = false
        try {
            sub.fire(false)
        } catch (e: InhExB) {
            sawB = true
        } catch (e: Exception) {
        }
        @Expect(sawB, true)
    }

    // CT-INH-012 / CT-INH-014
    @TestCase
    func testInh012SelectiveVariable() {
        let used = InhSubSelVar()
        var childInvariant = false
        try {
            used.bump(-100)
        } catch (e: ContractCheckInvariantException) {
            childInvariant = true
        }
        @Expect(childInvariant, true)

        let only = InhSubSelVarOnly()
        only.bump(-100)
        @Expect(only.selCount, -95)
    }

    // CT-INH-013
    @TestCase
    func testInh013SelectiveInvariant() {
        let sub = InhSubSelInv()
        var caught = false
        try {
            sub.bump(-100)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-018
    @TestCase
    func testInh018RevokeParent() {
        let sub = InhSubRevoked()
        sub.bump(-100)
        @Expect(sub.selCount, -95)
    }

    // CT-INH-019
    @TestCase
    func testInh019ReInherit() {
        let sub = InhSubReInherit()
        var caught = false
        try {
            sub.bump(-100)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-023
    @TestCase
    func testInh023DiamondOnce() {
        let d = InhDiamond()
        inhReset() // drop the constructor-exit invariant pass
        d.run()
        // Entry order root -> left -> right; the exit check repeats the same order.
        @Expect(inhTrace, "rlg|rlg")
    }

    // CT-INH-024
    @TestCase
    func testInh024DiamondOrder() {
        let d = InhDiamondRev()
        inhReset() // drop the constructor-exit invariant pass
        d.run()
        // Reversing the declared parent order reverses the check order.
        @Expect(inhTrace, "rgl|rgl")
    }

    // CT-INH-025
    @TestCase
    func testInh025DynamicDispatchOverride() {
        let base: InhDynBase = InhDynChild()
        inhReset()
        @Expect(base.virt(20), 21)
        @Expect(inhTrace, "pc")

        inhReset()
        var caught = false
        try {
            base.virt(5)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(inhTrace, "pc")
    }

    // CT-INH-026
    @TestCase
    func testInh026DynamicDispatchInherited() {
        let base: InhDynBase = InhDynChild()
        inhReset()
        @Expect(base.fixed(5), 5)
        @Expect(inhTrace, "f")
    }

    // CT-INH-027
    @TestCase
    func testInh027DefaultMethodContract() {
        let calc: InhDefaultCalc = InhDefaultUser()
        @Expect(calc.calc(1), 1)

        var caught = false
        try {
            calc.calc(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-028
    @TestCase
    func testInh028OverrideDefaultMethod() {
        let calc: InhDefaultCalc = InhDefaultOverride()
        @Expect(calc.calc(2), 3)

        var caught = false
        try {
            calc.calc(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-029
    @TestCase
    func testInh029GenericParent() {
        let ints: InhGenBase<Int64> = InhGenInt(7)
        @Expect(ints.get(), 7)

        let strs: InhGenBase<String> = InhGenStr("abc")
        @Expect(strs.get(), "abc")
    }

    // CT-INH-031
    @TestCase
    func testInh031RenameInvariants() {
        let sub = InhRenBoth()
        inhReset() // drop the constructor-exit invariant pass
        sub.run()
        @Expect(inhTrace, "bc|bc")
    }

    // CT-INH-032
    @TestCase
    func testInh032MixedPathOnce() {
        let d = InhMixD()
        inhReset() // drop the constructor-exit invariant pass
        d.act()
        // A.I1 is checked once even though both paths reach it.
        @Expect(inhTrace, "a|a")
    }

    // CT-INH-033
    @TestCase
    func testInh033MultiLevelDiamond() {
        let f = InhLayF()
        inhReset() // drop the constructor-exit invariant pass
        f.go()
        @Expect(inhTrace, "ABCDEF|ABCDEF")
    }

    // CT-INH-034
    @TestCase
    func testInh034ThreeGenerations() {
        let c = InhThreeC()
        @Expect(c.step(1), 3)

        var parentRequires = false
        try {
            c.step(2000)
        } catch (e: ContractCheckRequiresException) {
            parentRequires = true
        }
        @Expect(parentRequires, true)

        var childRequires = false
        try {
            c.step(50)
        } catch (e: ContractCheckRequiresException) {
            childRequires = true
        }
        @Expect(childRequires, true)

        var childEnsures = false
        try {
            c.step(48)
        } catch (e: ContractCheckEnsuresException) {
            childEnsures = true
        }
        @Expect(childEnsures, true)
    }

    // CT-INH-035
    @TestCase
    func testInh035SameLabelSameContent() {
        let sub = InhSameSub()
        @Expect(sub.work(2), 3)
    }

    // CT-INH-037
    @TestCase
    func testInh037StructImplementsInterface() {
        let iface: InhStructIface = InhStructImpl()
        @Expect(iface.apply(1), 2)

        var viaIface = false
        try {
            iface.apply(0)
        } catch (e: ContractCheckRequiresException) {
            viaIface = true
        }
        @Expect(viaIface, true)

        var direct = false
        try {
            InhStructImpl().apply(0)
        } catch (e: ContractCheckRequiresException) {
            direct = true
        }
        @Expect(direct, true)
    }

    // CT-INH-038
    @TestCase
    func testInh038RedeclaredInterfaceMember() {
        let impl: InhReB = InhReImpl()
        @Expect(impl.take(2), 2)

        var caught = false
        try {
            impl.take(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INH-039
    @TestCase
    func testInh039RenamedInvariantChain() {
        let sink = InhRenChainSink()
        inhReset() // drop the constructor-exit invariant pass
        sink.run()
        // The full inheritance keeps I1 and the renamed X side by side.
        @Expect(inhTrace, "dd|dd")

        let chain = InhRenChainC()
        inhReset() // drop the constructor-exit invariant pass
        chain.run()
        // I1, X and the second-generation rename Y are all checked.
        @Expect(inhTrace, "ddd|ddd")
    }

    // CT-INH-042
    @TestCase
    func testInh042ConformingPerParent() {
        let impl = InhConfImpl()
        @Expect(impl.b(20), 20)

        var ownCaught = false
        try {
            impl.b(5)
        } catch (e: ContractCheckRequiresException) {
            ownCaught = true
        }
        @Expect(ownCaught, true)

        var parentCaught = false
        try {
            impl.a(0)
        } catch (e: ContractCheckRequiresException) {
            parentCaught = true
        }
        @Expect(parentCaught, true)
    }

    // CT-INH-044: the generic interface's default member updates the shared
    // storage and the inherited invariant guards the implementation's members.
    @TestCase
    func testInh044GenericInterface() {
        let impl = InhGenericImpl()
        @Expect(impl.touch(0), 1)
        var caught = false
        try {
            impl.corrupt()
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
