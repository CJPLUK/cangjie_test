/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// CT-CLS-001~005/007/014/018~025 runtime cases. CT-CLS-017 (checks off) is
// covered by the compile-time `contract_check` dual build (design §3.5 / R8).
// The negative cases are split out by topic: CT-CLS-006/008/010~012/015/026
// live in this directory, while CT-CLS-009/013/016 are already covered by
// testNEG/test_neg_015_variable_init_member.cj,
// testNEG/test_neg_014_self_type_variable.cj and
// testNEG/test_neg_013_class_var_invariant_clash.cj.

import stdx.contract.macros.*

// CT-CLS-001: an instance auxiliary variable with an initializer is readable
// from both an invariant and a member-function contract, and holds the
// initializer value.
@Contract[
    variable count: Int64 = 5
    invariant [CountInvariant] count == 5
]
class ClsVarInit {
    public init() {}

    @Contract[
        requires count == 5
        ensures r: r == 5
    ]
    public func read(): Int64 {
        5
    }
}

// CT-CLS-002: a parameterless constructor may assign an auxiliary variable
// without an initializer from a `@ghost` block.
@Contract[
    variable token: Int64
    invariant [TokenInvariant] token == 7
]
class ClsCtorGhost {
    public init() {
        @ghost(
            token = 7
        )
    }
}

// CT-CLS-003: a parameterized constructor may assign an auxiliary variable from
// a `@ghost` block that reads the constructor parameter.
@Contract[
    variable total: Int64
    invariant [TotalInvariant] total == 3
]
class ClsPrimaryGhost {
    public init(seed: Int64) {
        @ghost(
            total = seed
        )
    }
}

// CT-CLS-004: a static auxiliary variable with an initializer is readable from
// a static invariant, which is checked when a static member function runs.
@Contract[
    static variable version: Int64 = 42
    static invariant [VersionInvariant] version == 42
]
class ClsStaticVarInit {
    public init() {}

    public static func touch(): Int64 {
        42
    }
}

// CT-CLS-005: `static init` may assign a static auxiliary variable from a
// `@ghost` block, and the static invariant sees the assigned value.
@Contract[
    static variable state: Int64
    static invariant [StateInvariant] state == 11
]
class ClsStaticGhostVar {
    static init() {
        @ghost(
            state = 11
        )
    }

    public init() {}

    public static func touch(): Int64 {
        11
    }
}

// CT-CLS-007: inside an instance member, `@ghost` may keep reading and writing
// both the instance auxiliary variable and the static auxiliary variable; the
// postcondition observes the written values.
@Contract[
    variable sink: Int64 = 0
    static variable shared: Int64 = 0
]
class ClsGhostReadWrite {
    public init() {}

    @Contract[
        ensures sink == 1
        ensures shared == 2
    ]
    public func bump(): Int64 {
        @ghost(
            sink = sink + 1
            shared = 2
        )
        1
    }
}

// CT-CLS-014: an auxiliary variable may use `Option<Self>` so that tree-like
// structures are allowed; storing `None` must compile and the invariant must
// accept it.
@Contract[
    variable child: Option<ClsSelfOption> = None
    invariant [ChildInvariant] child.isNone()
]
class ClsSelfOption {
    public init() {}
}

// CT-CLS-018: reading an auxiliary variable that has no initializer and was not
// assigned in the constructor raises ContractCheckGhostStateException at the
// constructor's invariant check point.
@Contract[
    variable pending: Int64
    invariant [PendingInvariant] pending >= 0
]
class ClsGhostState {
    public init() {}
}

// CT-CLS-019: a bare `return` inside a constructor still triggers the
// constructor-exit invariant check (design v2 §3.2.5): the early path leaves
// `seen == 0`, which violates the invariant even though control leaves via
// `return` instead of the end of the body.
@Contract[
    invariant [EarlyInvariant] seen == 1
]
class ClsCounterEarly {
    var seen: Int64 = 0

    public init(early: Bool) {
        seen = 1
        if (early) {
            seen = 0
            return
        }
    }
}

// CT-CLS-020: a class inheriting the same auxiliary variable from both a
// contract class and an interface compiles; the variable keeps a single storage
// and the constructor-exit invariant reads the shared value.
@Contract[
    variable sharedCount: Int64 = 1
    invariant [MergeParentInvariant] sharedCount == 1
]
open class ClsVarParent {
    public init() {}
}

@Contract[
    variable sharedCount: Int64 = 1
    invariant [MergeIfaceInvariant] sharedCount == 1
]
interface ClsVarIface {
}

@Contract[
    inherits from ClsVarParent
    inherits from ClsVarIface
]
class ClsVarMerge <: ClsVarParent & ClsVarIface {
    public init() {}
}

// CT-CLS-021: a property getter is wrapped with the invariant check even when
// the property itself declares no contract clauses (design v2 §3.2.5).
@Contract[
    invariant [PropInvariant] allowed == true
]
class ClsPropInvariant {
    var allowed: Bool = true

    public init() {}

    public prop value: Int64 {
        get() {
            allowed = false
            -1
        }
    }
}

// CT-CLS-022: L599 lists only instance constructors as invariant checkpoints;
// a `static init` exit is not a checkpoint, so a violating state left there is
// not reported at class initialization time. Reading the public static field
// triggers class initialization without hitting any member checkpoint.
@Contract[
    static invariant [StampInvariant] stamp > 50
]
class ClsStaticInitNoCheck {
    public static var stamp: Int64 = 100

    static init() {
        stamp = 10
    }
}

// CT-CLS-023 (documented deviation): contract expression evaluation suppresses
// nested contract checks (the `!contractInEvaluation()` gate), so `requires
// false` on the helper is not re-checked while the caller's `ensures` is being
// evaluated. This is a re-entrancy guard the spec does not define; the case
// pins the current behavior. A direct call still fires the helper's contract.
@Contract[
    requires false
]
func clsNestedHelper(): Bool {
    true
}

@Contract[
    ensures clsNestedHelper()
]
func clsNestedCaller(): Unit {}

// CT-CLS-024: an interface may declare an auxiliary variable (design L509/L513).
// The interface generates an abstract `mut prop`; a class that inherits the
// interface contract provides the `_abs_` storage, and the interface default
// member updates it via `@ghost` while its postcondition observes the value.
@Contract[
    variable level: Int64 = 1
]
interface ClsLevelled {
    @Contract[
        ensures r: r == level
    ]
    func bump(): Int64 {
        @ghost(
            level = level + 1
        )
        level
    }
}

@Contract[
    inherits from ClsLevelled
]
class ClsLevelledImpl <: ClsLevelled {
    public init() {}
}

// CT-CLS-025: a struct may declare an auxiliary variable; the constructor
// `@ghost` initializes it and a `mut` method updates it, observed by the
// method postcondition and the constructor-exit invariant.
@Contract[
    variable acc: Int64
    invariant [AccInvariant] acc >= 0
]
struct ClsAccBox {
    public init() {
        @ghost(
            acc = 10
        )
    }

    @Contract[
        ensures acc == 11
    ]
    public mut func bump(): Unit {
        @ghost(
            acc = acc + 1
        )
    }
}

@Test
class Test {
    // CT-CLS-001: construction and the member contract both read `count`.
    @TestCase
    func testCls001InstanceVarInit() {
        let obj = ClsVarInit()
        @Expect(obj.read(), 5)
    }

    // CT-CLS-002: the `@ghost` assignment in the constructor is visible to the
    // constructor-exit invariant.
    @TestCase
    func testCls002CtorGhostAssign() {
        let obj = ClsCtorGhost()
        @Expect(true, true)
    }

    // CT-CLS-003: the parameterized constructor assigns from its parameter.
    @TestCase
    func testCls003PrimaryCtorGhost() {
        let obj = ClsPrimaryGhost(3)
        @Expect(true, true)
    }

    // CT-CLS-004: the static invariant observes the initialized value.
    @TestCase
    func testCls004StaticVarInit() {
        @Expect(ClsStaticVarInit.touch(), 42)
    }

    // CT-CLS-005: `static init` assigns the static variable before use.
    @TestCase
    func testCls005StaticInitGhost() {
        @Expect(ClsStaticGhostVar.touch(), 11)
    }

    // CT-CLS-007: `@ghost` writes both storage kinds and the postcondition
    // confirms the values written from the instance member.
    @TestCase
    func testCls007GhostReadWrite() {
        let obj = ClsGhostReadWrite()
        @Expect(obj.bump(), 1)
    }

    // CT-CLS-014: `Option<Self>` is not a direct auxiliary variable type.
    @TestCase
    func testCls014SelfOption() {
        let obj = ClsSelfOption()
        @Expect(true, true)
    }

    // CT-CLS-018: the unassigned auxiliary variable raises the dedicated ghost
    // state exception when the constructor verifies the invariant.
    @TestCase
    func testCls018GhostStateException() {
        var caught = false
        try {
            let obj = ClsGhostState()
            @Expect(true, false)
        } catch (e: ContractCheckGhostStateException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // CT-CLS-019: the bare `return` path is checked; the normal path passes.
    @TestCase
    func testCls019BareReturnInvariant() {
        let ok = ClsCounterEarly(false)
        @Expect(true, true)

        var caught = false
        try {
            let obj = ClsCounterEarly(true)
            @Expect(true, false)
        } catch (e: ContractCheckInvariantException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // CT-CLS-020: the same-named variable from class and interface is merged,
    // and the constructor-exit invariant accepts the shared storage.
    @TestCase
    func testCls020MergedVariable() {
        let obj = ClsVarMerge()
        @Expect(true, true)
    }

    // CT-CLS-021: the getter body invalidates the invariant, so the generated
    // exit check raises even though the property has no contract clauses.
    @TestCase
    func testCls021PropertyInvariantCheck() {
        let obj = ClsPropInvariant()
        var caught = false
        try {
            let v = obj.value
            @Expect(v, -1)
        } catch (e: ContractCheckInvariantException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // CT-CLS-022: touching the class runs its `static init`, whose exit is not
    // a checkpoint — no invariant exception is raised, and the stored value is
    // visible afterwards.
    @TestCase
    func testCls022StaticInitIsNotCheckpoint() {
        @Expect(ClsStaticInitNoCheck.stamp, 10)
        @Expect(true, true)
    }

    // CT-CLS-023: the helper's `requires false` is suppressed during the
    // caller's contract evaluation, but fires on a direct call.
    @TestCase
    func testCls023NestedEvaluationSuppression() {
        var directCaught = false
        try {
            clsNestedHelper()
        } catch (e: ContractCheckRequiresException) {
            directCaught = true
            @Expect(isContractException(e), true)
        }
        @Expect(directCaught, true)
        clsNestedCaller()
        @Expect(true, true)
    }

    // CT-CLS-024: the implementing class provides the storage for the
    // interface variable; the default member's `@ghost` update is observed by
    // the inherited postcondition.
    @TestCase
    func testCls024InterfaceVariable() {
        let obj = ClsLevelledImpl()
        @Expect(obj.bump(), 2)
    }

    // CT-CLS-025: the constructor `@ghost` initializes the struct variable and
    // the `mut` method's `@ghost` update passes the postcondition.
    @TestCase
    func testCls025StructVariable() {
        var box = ClsAccBox()
        box.bump()
        @Expect(true, true)
    }
}
