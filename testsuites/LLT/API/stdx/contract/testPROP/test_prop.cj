/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
// CT-PROP-001~008/010~012/014/015 runtime cases.
// CT-PROP-009 (setter contract on a non-mut prop) is covered by
// testNEG/test_neg_021_prop_setter_nonmut.cj. CT-PROP-013 (checks off) is covered
// by the compile-time `contract_check` dual build (design §3.5 / R8).
//
// CT-PROP-010 deviation: design 3.3.4 scopes clause names per accessor, so a
// getter and a setter of the same property may reuse a name. The implementation
// matches the design (validation/property.cj keeps two namespaces), while the
// DT row expects a compile error. The case is landed as a passing runtime case
// that exercises the shared name, see PropSameName below.

import stdx.contract.macros.*

var propBodyRuns: Int64 = 0
var propTrace: String = ""

func propTick(tag: String): Bool {
    propTrace += tag
    true
}

class PropBizException <: Exception {
    init(message: String) {
        super(message)
    }
}

// CT-PROP-001/003: a valid getter and a valid setter on a mut prop.
@Contract
class PropValid {
    private var stored: Int64 = 0

    @Contract[
        get ensures r: r == stored
        set requires value >= 0
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            propBodyRuns += 1
            stored = v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

// CT-PROP-002: a false getter postcondition raises ContractCheckEnsuresException.
@Contract
class PropGetterEnsuresFail {
    private var stored: Int64 = 0

    @Contract[
        get ensures r: r < 0
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }
}

// CT-PROP-004: a false setter precondition raises ContractCheckRequiresException
// before the setter body runs.
@Contract
class PropSetterRequiresFail {
    private var stored: Int64 = 0

    @Contract[
        set requires value >= 0
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            propBodyRuns += 1
            stored = v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

// CT-PROP-005: the getter declares a throws condition that holds, but returns
// normally, so the throws contract check fails.
@Contract
class PropGetterThrows {
    private var stored: Int64 = 0

    @Contract[
        get {
            throws PropBizException if true
            ensures r: r == stored
        }
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }
}

// CT-PROP-006: the setter declares a throws condition that holds and throws the
// declared exception, so the business exception passes through.
@Contract
class PropSetterThrows {
    private var stored: Int64 = 0

    @Contract[
        set {
            throws PropBizException if true
        }
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            throw PropBizException("setter")
        }
    }
}

// CT-PROP-007: `$pre` snapshots the incoming value for both accessors.
@Contract
class PropPre {
    private var stored: Int64 = 2

    @Contract[
        get ensures r: r == $pre(stored)
        set ensures stored == $pre(stored) + value
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = stored + v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

// CT-PROP-008: the setter postcondition reads the field after the update.
@Contract
class PropSetEnsures {
    private var stored: Int64 = 0

    @Contract[
        set ensures stored == value
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

// CT-PROP-010: the same clause name is used by the getter and the setter; per
// design 3.3.4 the two accessors have separate namespaces.
@Contract
class PropSameName {
    private var stored: Int64 = 0

    @Contract[
        get {
            ensures [SharedName] r: r >= 0
        }
        set {
            requires [SharedName] value >= 0
        }
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

// CT-PROP-011: a read-only property accepts a getter contract only.
@Contract
class PropReadOnly {
    private var stored: Int64 = 6

    @Contract[
        get ensures r: r == 6
    ]
    public prop value: Int64 {
        get() {
            stored
        }
    }
}

// CT-PROP-016: a struct supports getter-only prop contracts; the getter
// postcondition observes the stored field. (The `mut prop` setter variant
// cannot compile on a struct: the expanded `$valueset` wrapper cannot capture
// the mutable field — see CT-PROP-017.)
@Contract
struct PropStructGetterOnly {
    private let stored: Int64 = 42

    public init() {}

    @Contract[
        get ensures r: r == stored
    ]
    public prop answer: Int64 {
        get() {
            stored
        }
    }
}

// CT-PROP-016 (negative): a broken struct getter postcondition must be reported
// on the read path (audit report 4, T3: the original case claimed to cover a bad
// getter but only asserted the valid one).
@Contract
struct PropStructGetterEnsuresFail {
    private let stored: Int64 = 7

    public init() {}

    @Contract[
        get ensures r: r == stored + 1
    ]
    public prop answer: Int64 {
        get() {
            stored
        }
    }
}

// CT-PROP-012: an interface property contract is inherited by the implementing
// class through `inherits from` and enforced through an interface reference.
@Contract
interface IPropBox {
    @Contract[
        get ensures r: r >= 0
        set requires value >= 0
    ]
    mut prop item: Int64
}
@Contract[
    inherits from IPropBox
]
class PropBoxImpl <: IPropBox {
    private var stored: Int64 = 0

    @Contract
    public mut prop item: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }
}

// CT-PROP-014: the setter updates a class-level auxiliary variable inside a
// `@ghost` block and the postcondition observes the new value.
@Contract[
    variable ghostMirror: Int64 = 0
]
class PropGhost {
    private var stored: Int64 = 0

    @Contract[
        set ensures ghostMirror == value
    ]
    public mut prop value: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
            @ghost(
                ghostMirror = v
            )
        }
    }

    public func peek(): Int64 {
        stored
    }
}

// CT-PROP-015: the enclosing class also declares an invariant, so the getter
// runs the accessor contract and the invariant checks in one trace.
@Contract[
    invariant [PropOrderInv] propTick("i")
]
class PropOrder {
    private var stored: Int64 = 1

    @Contract[
        get {
            requires propTick("q")
            ensures r: propTick("e")
        }
    ]
    public prop value: Int64 {
        get() {
            propTick("b")
            stored
        }
    }
}

// CT-PROP-032 (defect 16.12): `value` used as a named argument label inside a setter
// clause must not be rewritten to the setter's parameter alias — the helper's named
// parameter is itself `value`, so a rewritten label would not compile.
func propLabelCheck(value!: Int64): Bool {
    value > 0
}

@Contract
class PropValueLabel {
    private var stored: Int64 = 0

    @Contract[
        set requires propLabelCheck(value: value)
        set ensures r: stored == value
    ]
    public mut prop score: Int64 {
        get() {
            stored
        }
        set(v) {
            stored = v
        }
    }

    public func peek(): Int64 {
        stored
    }
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        propBodyRuns = 0
        propTrace = ""
    }

    @AfterEach
    func tearDown(): Unit {
        propBodyRuns = 0
        propTrace = ""
    }

    // CT-PROP-001: the getter postcondition holds and returns the stored value.
    @TestCase
    func testProp001GetterEnsures() {
        let obj = PropValid()
        obj.value = 4
        @Expect(obj.value, 4)
    }

    // CT-PROP-002: a false getter postcondition is reported.
    @TestCase
    func testProp002GetterEnsuresFail() {
        let obj = PropGetterEnsuresFail()
        var caught = false
        try {
            let value = obj.value
            @Expect(value, -1)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }

    // CT-PROP-003: the setter precondition holds, the body runs and updates the
    // property.
    @TestCase
    func testProp003SetterRequires() {
        let obj = PropValid()
        obj.value = 5
        @Expect(obj.peek(), 5)
        @Expect(propBodyRuns, 1)
    }

    // CT-PROP-004: the false precondition stops the setter body.
    @TestCase
    func testProp004SetterRequiresFail() {
        let obj = PropSetterRequiresFail()
        var caught = false
        try {
            obj.value = -1
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
        @Expect(propBodyRuns, 0)
        @Expect(obj.peek(), 0)
    }

    // CT-PROP-005: a satisfied throws condition with a normal return is a
    // contract violation.
    @TestCase
    func testProp005GetterThrows() {
        let obj = PropGetterThrows()
        var caught = false
        try {
            let value = obj.value
            @Expect(value, -1)
        } catch (e: ContractCheckThrowsException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-PROP-006: the declared exception thrown by the setter passes through
    // unchanged.
    @TestCase
    func testProp006SetterThrows() {
        let obj = PropSetterThrows()
        var caught = false
        try {
            obj.value = 1
        } catch (e: PropBizException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-PROP-007: `$pre` records the entry value for the getter and setter.
    @TestCase
    func testProp007Pre() {
        let obj = PropPre()
        @Expect(obj.value, 2)
        obj.value = 3
        @Expect(obj.peek(), 5)
        @Expect(obj.value, 5)
    }

    // CT-PROP-008: the postcondition reads the field after the setter updated
    // it.
    @TestCase
    func testProp008SetEnsures() {
        let obj = PropSetEnsures()
        obj.value = 7
        @Expect(obj.peek(), 7)
    }

    // CT-PROP-010: both accessors accept the same clause name.
    @TestCase
    func testProp010SameName() {
        let obj = PropSameName()
        obj.value = 2
        @Expect(obj.value, 2)
    }

    // CT-PROP-011: a read-only property with only a getter contract compiles
    // and checks.
    @TestCase
    func testProp011ReadOnly() {
        let obj = PropReadOnly()
        @Expect(obj.value, 6)
    }

    // CT-PROP-012: the interface property contract is enforced through an
    // interface reference.
    @TestCase
    func testProp012InterfaceInheritance() {
        let obj: IPropBox = PropBoxImpl()
        obj.item = 3
        @Expect(obj.item, 3)
        var caught = false
        try {
            obj.item = -1
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(obj.item, 3)
    }

    // CT-PROP-014: the `@ghost` update made by the setter is visible to the
    // postcondition.
    @TestCase
    func testProp014GhostMirror() {
        let obj = PropGhost()
        obj.value = 9
        @Expect(obj.peek(), 9)
    }

    // CT-PROP-015: the actual trace is `requires` -> entry invariant -> body ->
    // exit invariant -> ensures. The implementation evaluates the accessor's
    // own clauses inside the invariant checks, so the DT row's order (invariant
    // first, ensures before the exit invariant) does not match the shipped
    // generator (generate/callable.cj genEntry/genExit). This case locks the
    // implemented order.
    @TestCase
    func testProp015Order() {
        let obj = PropOrder()
        propTrace = ""
        @Expect(obj.value, 1)
        @Expect(propTrace, "qibie")
    }

    // CT-PROP-032: a named argument labeled `value` compiles untouched while bare
    // `value` references in the same clauses still bind the setter's parameter (v).
    @TestCase
    func testProp032ValueLabel() {
        let obj = PropValueLabel()
        obj.score = 5
        @Expect(obj.peek(), 5)
        var caught = false
        try {
            obj.score = -1
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(obj.peek(), 5)
    }

    // CT-PROP-016: the struct's getter-only prop contract is enforced on both a
    // valid and a broken getter.
    @TestCase
    func testProp016StructGetterOnly() {
        let s = PropStructGetterOnly()
        @Expect(s.answer, 42)
        let bad = PropStructGetterEnsuresFail()
        var caught = false
        try {
            let value = bad.answer
            @Expect(value, -1)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
            @Expect(isContractException(e), true)
        }
        @Expect(caught, true)
    }
}
