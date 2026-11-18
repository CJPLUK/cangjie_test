/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

// Note: CT-ENS-017 was removed together with the runtime switch APIs
// setCheckContract()/unsetCheckContract() (design §3.5 change: the switch is
// decided only by the compile-time `--cfg "contract_check=on"`); disabled-state
// behaviour is covered by the contract_verify cases in the stdx tree.

// CT-ENS-001 / CT-ENS-002: postcondition without a return identifier. The
// function returns its argument, so `x` is observed both as parameter and as
// the returned value.
@Contract[
    ensures x > 0
]
func ensPositiveReturn(x: Int64): Int64 {
    x
}

// CT-ENS-003 / CT-ENS-004: postcondition with a user-chosen return identifier.
@Contract[
    ensures r: r > 0
]
func ensNamedReturn(x: Int64): Int64 {
    x
}

// CT-ENS-005: several postconditions; the second one carries a side effect.
// Once the first one fails, the second must not be evaluated.
var ensSideEffectCount: Int64 = 0

func ensSideEffectTrue(): Bool {
    ensSideEffectCount += 1
    true
}

@Contract[
    ensures firstFails
    ensures ensSideEffectTrue()
]
func ensPostShortCircuit(firstFails: Bool): Unit {
}

// CT-ENS-006: a function that exits by throwing a business exception. The
// postcondition must not be checked on the exceptional exit.
class EnsBusinessException <: Exception {
    init(message: String) {
        super(message)
    }
}

@Contract[
    ensures false
]
func ensThrowsBusiness(): Unit {
    throw EnsBusinessException("ens business failure")
}

// CT-ENS-007: `$pre` snapshots a value at entry. `value` is an Int64 member,
// so the snapshot is a copy and the entry value can be compared with the exit
// value. Deviation (DT design doc 20/R3): the design spells `@pre`, the
// current implementation uses `$pre`.
@Contract
class EnsValueSnapshot {
    public var value: Int64 = 0

    @Contract[
        ensures $pre(value) < value
    ]
    public func increment(): Unit {
        value += 1
    }
}

// CT-ENS-008: for a reference type `$pre` only captures the reference. The
// body mutates the object, so the snapshot observes the mutated value too and
// the condition fails.
class EnsPoint {
    public var x: Int64

    init(x: Int64) {
        this.x = x
    }
}

@Contract[
    ensures $pre(pt).x > pt.x
]
func ensMutatePoint(pt: EnsPoint): Unit {
    pt.x -= 1
}

// CT-ENS-010: the same side-effecting expression appears twice inside `$pre`.
// Each occurrence is evaluated once at entry, so the counter grows by two.
var ensPreEvalCount: Int64 = 0

func ensPreProbe(): Int64 {
    ensPreEvalCount += 1
    1
}

@Contract[
    ensures $pre(ensPreProbe()) == 1 && $pre(ensPreProbe()) == 1
]
func ensTwoSnapshots(): Unit {
}

// CT-ENS-013: `result` and `value` are legal return identifiers.
@Contract[
    ensures result: result == 5
]
func ensResultName(): Int64 {
    5
}

@Contract[
    ensures value: value == 6
]
func ensValueName(): Int64 {
    6
}

// CT-ENS-014: postconditions on a generic function are evaluated for the
// instantiated type, hence the `T <: Equatable<T>` bound.
@Contract[
    ensures r: r == x
]
func ensIdentity<T>(x: T): T where T <: Equatable<T> {
    x
}

@Contract[
    ensures r: r == x
]
func ensChoose<T>(x: T, y: T): T where T <: Equatable<T> {
    y
}

// CT-ENS-015: every normal exit is checked, including early `return`s from
// the body.
@Contract[
    ensures r: r > 0
]
func ensEarlyReturn(x: Int64): Int64 {
    if (x < 0) {
        return -1
    }
    if (x == 0) {
        return 1
    }
    x
}

// CT-ENS-016: postcondition on a constructor. The enclosing type carries
// `@Contract` as required by the implementation.
@Contract
class EnsCheckedPoint {
    public var x: Int64

    @Contract[
        ensures this.x > 0
    ]
    init(x: Int64) {
        this.x = x
    }
}

// CT-ENS-018 (R9): DT expects a compile error when an `extend` member's
// `ensures` return name collides with a member of the extended type. The
// implementation collects member names only from the `extend` body
// (generate/interface.cj genExtendContract -> collectMemberNames on the extend
// body), so the type's own members are invisible and no diagnostic is emitted.
// The case is therefore pinned as a runtime regression that documents the
// actual semantics: the return-name binding shadows the member, i.e. `member`
// in the postcondition observes the return value, not the field.
@Contract
class EnsExtendTarget {
    public var member: Int64 = 5
}

@Contract
extend EnsExtendTarget {
    @Contract[
        ensures member: member > 0
    ]
    public func zero(): Int64 {
        0
    }

    @Contract[
        ensures member: member > 0
    ]
    public func one(): Int64 {
        1
    }
}

// CT-ENS-021 (R9): a return identifier that is not a member of the class is
// legal and the postcondition takes effect.
@Contract
class EnsLegalReturnName {
    public var inner: Int64 = 0

    @Contract[
        ensures result: result > 0
    ]
    public func compute(x: Int64): Int64 {
        x
    }
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        ensSideEffectCount = 0
        ensPreEvalCount = 0
    }

    @AfterEach
    func tearDown(): Unit {
        ensSideEffectCount = 0
        ensPreEvalCount = 0
    }

    // CT-ENS-001: `ensures x > 0` holds for x = 1; the call returns normally.
    @TestCase
    func testEns001PostconditionHolds() {
        @Expect(ensPositiveReturn(1), 1)
    }

    // CT-ENS-002: the same postcondition fails for x = 0; a
    // ContractCheckEnsuresException is thrown.
    @TestCase
    func testEns002PostconditionViolated() {
        var caught = false
        try {
            ensPositiveReturn(0)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
            @Expect(e.message.contains("ensures x > 0"), true)
        }
        @Expect(caught, true)
    }

    // CT-ENS-003: `ensures r: r > 0` holds for the returned value 1.
    @TestCase
    func testEns003NamedReturnHolds() {
        @Expect(ensNamedReturn(1), 1)
    }

    // CT-ENS-004: the named postcondition fails for the returned value 0.
    @TestCase
    func testEns004NamedReturnViolated() {
        var caught = false
        try {
            ensNamedReturn(0)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
            @Expect(e.message.contains("ensures r: r > 0"), true)
        }
        @Expect(caught, true)
    }

    // CT-ENS-005: the first postcondition fails. The exception is thrown and
    // the second, side-effecting postcondition is not evaluated. The control
    // call proves the second clause does fire when the first one holds.
    @TestCase
    func testEns005ShortCircuitOnFirstFailure() {
        ensSideEffectCount = 0
        var caught = false
        try {
            ensPostShortCircuit(false)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(ensSideEffectCount, 0)

        ensPostShortCircuit(true)
        @Expect(ensSideEffectCount, 1)
    }

    // CT-ENS-006: the function exits by throwing a business exception. The
    // postcondition is skipped and the business exception propagates unchanged.
    @TestCase
    func testEns006ExceptionExitSkipsEnsures() {
        var caught = false
        try {
            ensThrowsBusiness()
        } catch (e: EnsBusinessException) {
            caught = true
            @Expect(e.message, "ens business failure")
            @Expect(isContractException(e), false)
        }
        @Expect(caught, true)
    }

    // CT-ENS-007: the entry snapshot of the value-type member is smaller than
    // the value after the body has run, so the postcondition holds.
    @TestCase
    func testEns007PreSnapshotValue() {
        let snapshot = EnsValueSnapshot()
        snapshot.increment()
        @Expect(snapshot.value, 1)
        snapshot.increment()
        @Expect(snapshot.value, 2)
    }

    // CT-ENS-008: `$pre(pt)` captures only the reference; after the body
    // mutates pt.x both sides see the same value, so the condition fails.
    @TestCase
    func testEns008PreSnapshotReference() {
        let pt = EnsPoint(5)
        var caught = false
        try {
            ensMutatePoint(pt)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
        // The body ran before the postcondition was checked.
        @Expect(pt.x, 4)
    }

    // CT-ENS-010: both `$pre(e)` occurrences are evaluated once at entry, so
    // the side-effect counter increases by two.
    @TestCase
    func testEns010EachPreOccurrenceEvaluated() {
        ensPreEvalCount = 0
        ensTwoSnapshots()
        @Expect(ensPreEvalCount, 2)
    }

    // CT-ENS-013: `result` and `value` are accepted as return identifiers and
    // the postconditions hold.
    @TestCase
    func testEns013LegalReturnNames() {
        @Expect(ensResultName(), 5)
        @Expect(ensValueName(), 6)
    }

    // CT-ENS-014: the generic postcondition is evaluated correctly for Int64
    // and String instantiations, both when it holds and when it fails.
    @TestCase
    func testEns014GenericInstantiation() {
        @Expect(ensIdentity<Int64>(7), 7)
        @Expect(ensIdentity<String>("abc"), "abc")
        @Expect(ensChoose<Int64>(1, 1), 1)
        @Expect(ensChoose<String>("a", "a"), "a")

        var intCaught = false
        try {
            ensChoose<Int64>(1, 2)
        } catch (e: ContractCheckEnsuresException) {
            intCaught = true
        }
        @Expect(intCaught, true)

        var stringCaught = false
        try {
            ensChoose<String>("a", "b")
        } catch (e: ContractCheckEnsuresException) {
            stringCaught = true
        }
        @Expect(stringCaught, true)
    }

    // CT-ENS-015: postconditions are checked after an early return. A
    // violating early return throws, while the valid early and final exits
    // return normally.
    @TestCase
    func testEns015EarlyReturnChecked() {
        @Expect(ensEarlyReturn(0), 1)
        @Expect(ensEarlyReturn(5), 5)

        var caught = false
        try {
            ensEarlyReturn(-1)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-ENS-016: a constructor checks its postcondition on normal exit; a
    // violating construction leaves no object behind and throws.
    @TestCase
    func testEns016ConstructorEnsures() {
        let point = EnsCheckedPoint(3)
        @Expect(point.x, 3)

        var caught = false
        try {
            EnsCheckedPoint(-3)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-ENS-018: documented deviation. The collision between the `ensures`
    // return name and a member of the extended type is not diagnosed; the
    // return-name binding shadows the member, so `zero()` violates the
    // postcondition while `one()` satisfies it even though the field is 5.
    @TestCase
    func testEns018ExtendReturnNameShadowing() {
        let target = EnsExtendTarget()
        @Expect(target.member, 5)
        @Expect(target.one(), 1)

        var caught = false
        try {
            target.zero()
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-ENS-021: `result` is not a member of the class, so it is a legal
    // return identifier and the postcondition is enforced.
    @TestCase
    func testEns021LegalReturnName() {
        let obj = EnsLegalReturnName()
        @Expect(obj.compute(3), 3)

        var caught = false
        try {
            obj.compute(0)
        } catch (e: ContractCheckEnsuresException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
