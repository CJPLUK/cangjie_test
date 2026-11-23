/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// CT-INV-001~011/013~018/020~025 runtime cases. The compile-time cases
// CT-INV-012 (static invariant reads an instance member) and CT-INV-019
// (duplicate invariant names) live in dedicated negative files in this
// directory.

import stdx.contract.macros.*

var invCount: Int64 = 0
var invTrace: String = ""
var invBodyRuns: Int64 = 0
var invBreakExit: Bool = false
var invEntryFlag: Bool = true

func invTick(tag: String): Bool {
    invCount += 1
    invTrace += tag
    true
}

func invNever(): Bool {
    false
}

func invExitProbe(): Bool {
    invCount += 1
    invTrace += "e"
    !invBreakExit
}

func resetInv(): Unit {
    invCount = 0
    invTrace = ""
    invBodyRuns = 0
}

class InvBizException <: Exception {
    init(message: String) {
        super(message)
    }
}

// CT-INV-001: a public method passes the invariant at entry and exit.
@Contract[
    invariant [I001] invTick("i")
]
class InvBasic {
    public init() {}

    public func run(): Unit {}
}

// CT-INV-002: a method that throws a business exception still checks the
// invariant on the exceptional exit, and the broken invariant wins.
@Contract[
    invariant [I002] invExitProbe()
]
class InvExceptExit {
    public init() {}

    public func boom(): Unit {
        invBreakExit = true
        throw InvBizException("boom")
    }
}

// CT-INV-003: entry order is requires -> throws conditions -> static invariant
// -> instance invariant.
@Contract[
    static invariant [SI003] invTick("s")
    invariant [II003] invTick("i")
]
class InvOrderEntry {
    public init() {}

    @Contract[
        requires invTick("q")
        throws InvBizException if invTick("t") && invNever()
    ]
    public func run(): Unit {
        invTrace += "b"
    }
}

// CT-INV-004: exit order is static invariant -> instance invariant -> ensures.
@Contract[
    static invariant [SI004] invTick("s")
    invariant [II004] invTick("i")
]
class InvOrderExit {
    public init() {}

    @Contract[
        ensures r: invTick("e")
    ]
    public func run(): Int64 {
        invTrace += "b"
        1
    }
}

// CT-INV-005: on the exceptional exit the order is static invariant -> instance
// invariant -> throws check, and the recorded throws condition then fires.
@Contract[
    static invariant [SI005] invTick("s")
    invariant [II005] invTick("i")
]
class InvOrderExcept {
    public init() {}

    @Contract[
        throws InvBizException if invTick("t")
    ]
    public func run(): Unit {
        invTrace += "b"
        throw InvBizException("boom")
    }
}

// CT-INV-006: `on_public` checks only public members (and constructors).
@Contract[
    on_public invariant [V006] invTick("v")
]
open class InvVisPublic {
    public init() {}

    public func pub(): Unit {}

    protected func prot(): Unit {}

    func pkg(): Unit {}

    private func priv(): Unit {}

    public func callPrivate(): Unit {
        priv()
    }
}

// CT-INV-007: `on_protected` checks public and protected members.
@Contract[
    on_protected invariant [V007] invTick("v")
]
open class InvVisProtected {
    public init() {}

    public func pub(): Unit {}

    protected func prot(): Unit {}

    func pkg(): Unit {}

    private func priv(): Unit {}

    public func callPrivate(): Unit {
        priv()
    }
}

// CT-INV-008: `on_private` checks every visibility.
@Contract[
    on_private invariant [V008] invTick("v")
]
open class InvVisPrivate {
    public init() {}

    public func pub(): Unit {}

    protected func prot(): Unit {}

    func pkg(): Unit {}

    private func priv(): Unit {}

    public func callPrivate(): Unit {
        priv()
    }
}

// CT-INV-009: without a selector, public/protected/package members are checked
// while private members are not.
@Contract[
    invariant [V009] invTick("v")
]
open class InvVisDefault {
    public init() {}

    public func pub(): Unit {}

    protected func prot(): Unit {}

    func pkg(): Unit {}

    private func priv(): Unit {}

    public func callPrivate(): Unit {
        priv()
    }
}

// CT-INV-010/011: a type with both a static and an instance invariant.
@Contract[
    static invariant [SI010] invTick("s")
    invariant [II010] invTick("i")
]
class InvStaticAndInstance {
    public init() {}

    public static func staticProbe(): Unit {}

    public func instanceProbe(): Unit {}
}

// CT-INV-013: a non-open class checks the invariant at the constructor exit and
// rejects a broken invariant.
@Contract[
    variable ready: Bool = false
    invariant [I013] ready
]
class InvCtorViolation {
    public init() {}
}

// CT-INV-014: an open class does not check invariants in its constructor.
@Contract[
    variable ready14: Bool = false
    invariant [I014] ready14
]
open class InvOpenCtor {
    public init() {}
}

// CT-INV-015: at the constructor exit the static invariant runs before the
// instance invariant.
@Contract[
    static invariant [SI015] invTick("s")
    invariant [II015] invTick("i")
]
class InvCtorOrder {
    public init() {}
}

// CT-INV-016: a member that breaks the invariant makes the exit check raise the
// dedicated invariant exception.
@Contract[
    variable ok16: Bool = true
    invariant [I016] ok16
]
class InvViolation {
    public init() {}

    public func breakIt(): Unit {
        @ghost(
            ok16 = false
        )
    }
}

// CT-INV-017: a false entry invariant aborts the call before the body runs.
@Contract[
    invariant [I017] invEntryFlag
]
class InvEntryFail {
    public init() {}

    public func run(): Unit {
        invBodyRuns += 1
    }
}

// CT-INV-018: named invariants are evaluated normally, in source order.
@Contract[
    invariant [InvOne] invTick("n1")
    invariant [InvTwo] invTick("n2")
]
class InvNamed {
    public init() {}

    public func run(): Unit {}
}

// CT-INV-020/021: a struct with a mut method that may or may not keep the
// invariant.
@Contract[
    invariant [I020] value20 >= 0
]
struct InvStructBreak {
    var value20: Int64 = 0

    public init() {}

    public mut func setValue(v: Int64): Unit {
        value20 = v
    }
}

@Contract[
    invariant [I021] invTick("s") && value21 >= 0
]
struct InvStructKeep {
    var value21: Int64 = 0

    public init() {}

    public mut func setValue(v: Int64): Unit {
        value21 = v
    }
}

// CT-INV-022: a struct constructor checks the invariant at its exit.
@Contract[
    invariant [I022] value22 > 0
]
struct InvStructCtor {
    var value22: Int64 = 0

    public init() {}
}

// CT-INV-023: a class inherits the invariant declared by its interface through
// `inherits from` and checks it with the implementation's visibility.
@Contract[
    invariant [I023] invTick("if")
]
interface InvInterface {
    func ok(): Bool
}

@Contract[
    inherits from InvInterface
]
class InvImplementation <: InvInterface {
    public init() {}

    public func ok(): Bool {
        true
    }

    public func probe(): Int64 {
        1
    }
}

// CT-INV-024: a struct mut method that throws keeps the invariant, so the
// business exception propagates; if the invariant is broken the invariant
// exception replaces it.
@Contract[
    invariant [I024] value24 >= 0
]
struct InvStructExcept {
    var value24: Int64 = 0

    public init() {}

    public mut func keepThrow(): Unit {
        throw InvBizException("keep")
    }

    public mut func breakThrow(): Unit {
        value24 = -1
        throw InvBizException("break")
    }
}

// CT-INV-025: value copies do not check invariants; the next member call does.
@Contract[
    invariant [I025] invTick("c") && value25 >= 0
]
struct InvStructCopy {
    var value25: Int64 = 0

    public init() {}

    public func getValue(): Int64 {
        value25
    }
}

func invPassThrough(input: InvStructCopy): InvStructCopy {
    input
}

// CT-INV-026: a struct supports `static variable` + `static invariant`; the
// static member's `@ghost` update is observed by the static postcondition and
// guarded by the static invariant.
@Contract[
    static variable counter: Int64 = 0
    static invariant [SCnt] counter >= 0
]
struct InvStructStatic {
    public init() {}

    @Contract[
        ensures counter == 1
    ]
    public static func bump(): Unit {
        @ghost(
            counter = counter + 1
        )
    }
}

// CT-INV-027: `on_private` lifts the visibility filter for a struct, so the
// private `mut` member is also checkpointed.
@Contract[
    variable value27: Int64 = 1
    on_private invariant [I027] value27 >= 0
]
struct InvStructPrivate {
    public init() {}

    private mut func corrupt(): Unit {
        @ghost(
            value27 = -1
        )
    }

    public mut func viaPrivate(): Unit {
        corrupt()
    }
}

// CT-INV-028: an `immut` method (no `mut`) is still checkpointed at entry and
// exit; the postcondition observes the variable.
@Contract[
    variable value28: Int64 = 1
    invariant [I028] value28 >= 0
]
struct InvStructImmut {
    public init() {}

    @Contract[
        ensures r: r == value28
    ]
    public func peek(): Int64 {
        value28
    }
}

// CT-INV-029: an interface default member is checkpointed with the inherited
// invariant (fixed, defect 16.15; see contract-defects-audit.md). The
// implementor derives the interface's per-origin checker and the default
// member's exit checkpoint fires when the `@ghost` update corrupts storage.
@Contract[
    variable level: Int64 = 1
    invariant [I029] level >= 0
]
interface InvLevelledDefault {
    func bumpDown(): Int64 {
        @ghost(
            level = level - 5
        )
        level
    }
}

@Contract[
    inherits from InvLevelledDefault
]
class InvLevelledDefaultImpl <: InvLevelledDefault {
    public init() {}
}

// CT-INV-030: a struct with multiple constructors checks the invariant at
// every constructor exit; the ghost storage persists across the choices.
@Contract[
    variable value30: Int64 = 0
    invariant [I030] value30 >= 0
]
struct InvStructMultiCtor {
    public init() {}

    public init(n: Int64) {
        @ghost(
            value30 = n
        )
    }

    public func value(): Int64 {
        @contractAssert(value30 >= 0)
        value30
    }
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        resetInv()
        invBreakExit = false
        invEntryFlag = true
    }

    @AfterEach
    func tearDown(): Unit {
        resetInv()
        invBreakExit = false
        invEntryFlag = true
    }

    // CT-INV-001: one check at entry and one at exit.
    @TestCase
    func testInv001EntryAndExit() {
        let obj = InvBasic()
        resetInv()
        obj.run()
        @Expect(invCount, 2)
        @Expect(invTrace, "ii")
    }

    // CT-INV-002: the exceptional exit checks the invariant, and since it is
    // broken the invariant exception replaces the business exception.
    @TestCase
    func testInv002ExceptionalExit() {
        let obj = InvExceptExit()
        resetInv()
        invBreakExit = false
        var caught = false
        try {
            obj.boom()
        } catch (e: ContractCheckInvariantException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
        @Expect(invTrace, "ee")
    }

    // CT-INV-003: entry trace is "qtsi" and the body runs afterwards.
    @TestCase
    func testInv003EntryOrder() {
        let obj = InvOrderEntry()
        resetInv()
        obj.run()
        @Expect(invTrace, "qtsibsi")
        @Expect(invCount, 6)
    }

    // CT-INV-004: exit trace is "si" followed by the ensures probe "e".
    @TestCase
    func testInv004ExitOrder() {
        let obj = InvOrderExit()
        resetInv()
        @Expect(obj.run(), 1)
        @Expect(invTrace, "sibsie")
    }

    // CT-INV-005: the recorded throws condition fires after the exit invariants.
    @TestCase
    func testInv005ExceptionalOrder() {
        let obj = InvOrderExcept()
        resetInv()
        var caught = false
        try {
            obj.run()
        } catch (e: InvBizException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(invTrace, "tsibsi")
    }

    // CT-INV-006: only the public method is checked; the private method reached
    // through a public wrapper is not checked itself.
    @TestCase
    func testInv006OnPublic() {
        let obj = InvVisPublic()
        resetInv()
        obj.pub()
        @Expect(invCount, 2)
        resetInv()
        obj.prot()
        @Expect(invCount, 0)
        resetInv()
        obj.pkg()
        @Expect(invCount, 0)
        resetInv()
        obj.callPrivate()
        @Expect(invCount, 2)
    }

    // CT-INV-007: public and protected methods are checked, package is not.
    @TestCase
    func testInv007OnProtected() {
        let obj = InvVisProtected()
        resetInv()
        obj.pub()
        @Expect(invCount, 2)
        resetInv()
        obj.prot()
        @Expect(invCount, 2)
        resetInv()
        obj.pkg()
        @Expect(invCount, 0)
        resetInv()
        obj.callPrivate()
        @Expect(invCount, 2)
    }

    // CT-INV-008: every method visibility is checked.
    @TestCase
    func testInv008OnPrivate() {
        let obj = InvVisPrivate()
        resetInv()
        obj.pub()
        @Expect(invCount, 2)
        resetInv()
        obj.prot()
        @Expect(invCount, 2)
        resetInv()
        obj.pkg()
        @Expect(invCount, 2)
        resetInv()
        obj.callPrivate()
        @Expect(invCount, 4)
    }

    // CT-INV-009: the default selector skips private methods only.
    @TestCase
    func testInv009DefaultSelector() {
        let obj = InvVisDefault()
        resetInv()
        obj.pub()
        @Expect(invCount, 2)
        resetInv()
        obj.prot()
        @Expect(invCount, 2)
        resetInv()
        obj.pkg()
        @Expect(invCount, 2)
        resetInv()
        obj.callPrivate()
        @Expect(invCount, 2)
    }

    // CT-INV-010: a static member function checks only the static invariant.
    @TestCase
    func testInv010StaticMember() {
        InvStaticAndInstance()
        resetInv()
        InvStaticAndInstance.staticProbe()
        @Expect(invTrace, "ss")
    }

    // CT-INV-011: an instance member function checks static then instance.
    @TestCase
    func testInv011InstanceMember() {
        let obj = InvStaticAndInstance()
        resetInv()
        obj.instanceProbe()
        @Expect(invTrace, "sisi")
    }

    // CT-INV-013: constructing a non-open class with a broken invariant raises
    // the dedicated exception.
    @TestCase
    func testInv013CtorViolation() {
        var caught = false
        try {
            let obj = InvCtorViolation()
            @Expect(true, false)
        } catch (e: ContractCheckInvariantException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // CT-INV-014: an open class constructor performs no invariant check.
    @TestCase
    func testInv014OpenCtor() {
        let obj = InvOpenCtor()
        @Expect(true, true)
    }

    // CT-INV-015: the constructor exit checks static before instance.
    @TestCase
    func testInv015CtorOrder() {
        resetInv()
        let obj = InvCtorOrder()
        @Expect(invTrace, "si")
    }

    // CT-INV-016: the exit check raises the invariant exception.
    @TestCase
    func testInv016Violation() {
        let obj = InvViolation()
        var caught = false
        try {
            obj.breakIt()
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INV-017: a false entry invariant prevents the body from running.
    @TestCase
    func testInv017EntryFail() {
        let obj = InvEntryFail()
        resetInv()
        invEntryFlag = false
        var caught = false
        try {
            obj.run()
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(invBodyRuns, 0)
    }

    // CT-INV-018: both named invariants run in source order at every check
    // point.
    @TestCase
    func testInv018Named() {
        let obj = InvNamed()
        resetInv()
        obj.run()
        @Expect(invTrace, "n1n2n1n2")
        @Expect(invCount, 4)
    }

    // CT-INV-020: the mut method breaks the invariant, so the exit check throws.
    @TestCase
    func testInv020StructBreak() {
        var obj = InvStructBreak()
        var caught = false
        try {
            obj.setValue(-1)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INV-021: the mut method keeps the invariant, so both checks pass.
    @TestCase
    func testInv021StructKeep() {
        var obj = InvStructKeep()
        resetInv()
        obj.setValue(5)
        @Expect(invCount, 2)
        @Expect(invTrace, "ss")
    }

    // CT-INV-022: the struct constructor rejects a broken invariant.
    @TestCase
    func testInv022StructCtor() {
        var caught = false
        try {
            let obj = InvStructCtor()
            @Expect(true, false)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-INV-023: the implementation class checks the inherited interface
    // invariant at entry and exit.
    @TestCase
    func testInv023InterfaceInvariant() {
        let obj = InvImplementation()
        resetInv()
        @Expect(obj.probe(), 1)
        @Expect(invTrace, "ifif")
    }

    // CT-INV-024: a preserved invariant lets the business exception through; a
    // broken one is reported as an invariant violation.
    @TestCase
    func testInv024StructExceptionalExit() {
        var obj = InvStructExcept()
        var business = false
        try {
            obj.keepThrow()
        } catch (e: InvBizException) {
            business = true
        }
        @Expect(business, true)

        var invariant = false
        try {
            obj.breakThrow()
        } catch (e: ContractCheckInvariantException) {
            invariant = true
        }
        @Expect(invariant, true)
    }

    // CT-INV-025: copies do not check the invariant; the following member call
    // performs exactly one entry and one exit check.
    @TestCase
    func testInv025ValueCopy() {
        let first = InvStructCopy()
        resetInv()
        let second = first
        let third = invPassThrough(first)
        let fourth = invPassThrough(third)
        @Expect(invCount, 0)
        @Expect(second.getValue(), 0)
        @Expect(invCount, 2)
        @Expect(fourth.getValue(), 0)
        @Expect(invCount, 4)
    }

    // CT-INV-026: the struct's static invariant guards the static member; the
    // static `@ghost` update satisfies the static postcondition.
    @TestCase
    func testInv026StructStatic() {
        InvStructStatic.bump()
        @Expect(true, true)
    }

    // CT-INV-027: with `on_private`, the corrupting private member raises the
    // invariant exception at its exit.
    @TestCase
    func testInv027StructOnPrivate() {
        var box = InvStructPrivate()
        try {
            box.viaPrivate()
            @Expect(true, false)
        } catch (e: ContractCheckInvariantException) {
            @Expect(true, true)
        }
    }

    // CT-INV-028: the immut method is checkpointed at entry and exit and its
    // postcondition observes the variable.
    @TestCase
    func testInv028StructImmut() {
        let box = InvStructImmut()
        @Expect(box.peek(), 1)
    }

    // CT-INV-029: the interface default member is checkpointed with the
    // implementor's inherited invariant; corrupting the shared storage throws.
    @TestCase
    func testInv029InterfaceDefaultEscape() {
        let obj = InvLevelledDefaultImpl()
        try {
            obj.bumpDown()
            @Expect(true, false)
        } catch (e: ContractCheckInvariantException) {
            @Expect(true, true)
        }
    }

    // CT-INV-030: both constructor exits pass the invariant and the ghost
    // storage from the second constructor stays observable afterwards.
    @TestCase
    func testInv030StructMultiCtor() {
        let a = InvStructMultiCtor()
        let b = InvStructMultiCtor(7)
        @Expect(b.value(), 7)
        @Expect(true, true)
    }
}
