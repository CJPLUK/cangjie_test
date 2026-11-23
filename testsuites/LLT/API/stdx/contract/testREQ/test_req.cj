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

// Note: CT-REQ-011 was removed together with the runtime switch APIs
// setCheckContract()/unsetCheckContract() (design §3.5 change: the switch is
// decided only by the compile-time `--cfg "contract_check=on"`); disabled-state
// behaviour is covered by the contract_verify cases in the stdx tree.

// CT-REQ-001 / CT-REQ-002: a single precondition on the parameter `x`.
@Contract[
    requires x > 0
]
func requirePositive(x: Int64): Int64 {
    x
}

// CT-REQ-003: two preconditions that must both hold.
@Contract[
    requires x > 0
    requires x < 100
]
func requireInRange(x: Int64): Int64 {
    x
}

// CT-REQ-004: the second precondition carries a side effect. Once the first one
// has failed it must not be evaluated, and the function body must not run.
var requiresSideEffectCount: Int64 = 0
var requiresBodyCount: Int64 = 0

func requiresSideEffectTrue(): Bool {
    requiresSideEffectCount += 1
    true
}

@Contract[
    requires x > 0
    requires requiresSideEffectTrue()
]
func requireFirstFailsSecondSideEffect(x: Int64): Unit {
    requiresBodyCount += 1
}

// CT-REQ-005: preconditions referring to a parameter, a package-level variable,
// a member variable and a function-level auxiliary variable respectively.
// `x` and `y` are kept apart so that each clause can be violated in isolation.
var globalThreshold: Int64 = 3

@Contract
class SymbolScope {
    public var memberFloor: Int64 = 1

    @Contract[
        variable localLimit: Int64 = 4
        requires x > 0
        requires y >= globalThreshold
        requires y >= memberFloor
        requires y > localLimit
    ]
    public func check(x: Int64, y: Int64): Unit {
    }
}

// CT-REQ-006: local variables declared in the body share the name of the
// parameter / member variable. `requires` must still resolve to the parameter
// / member, unaffected by the shadowing local.
@Contract[
    requires x > 0
]
func shadowedParamInBody(x: Int64): Int64 {
    var result = 0
    if (result == 0) {
        let x = -1
        result = x
    }
    result
}

@Contract
class MemberShadowScope {
    public var limit: Int64 = 5

    @Contract[
        requires limit > 0
    ]
    public func shadowedMemberInBody(): Int64 {
        var result = 0
        if (result == 0) {
            let limit = -1
            result = limit
        }
        result
    }
}

// CT-REQ-007: body side-effect probe. The body counter must stay zero when the
// precondition fails, i.e. the body never executes.
class BodyProbe {
    var count: Int64 = 0
}

@Contract[
    requires false
]
func rejectAlways(probe: BodyProbe): Unit {
    probe.count += 1
}

// CT-REQ-008: named precondition. The `[r1]` label selects the clause for
// inheritance and must not change how the condition is judged.
@Contract[
    requires [r1] x > 0
]
func requireNamedPositive(x: Int64): Int64 {
    x
}

// CT-REQ-009: the precondition calls a pure function; its return value is what
// the check evaluates.
func isEven(x: Int64): Bool {
    x % 2 == 0
}

@Contract[
    requires isEven(x)
]
func requireEven(x: Int64): Int64 {
    x
}

// CT-REQ-010: the precondition expression throws a business exception.
// Design 3.2.1 does not define this case (see DT design doc 20/R7); the current
// implementation lets the business exception propagate unchanged, which is what
// this case verifies.
class BusinessException <: Exception {
    init(message: String) {
        super(message)
    }
}

func throwingPredicate(x: Int64): Bool {
    if (x < 0) {
        throw BusinessException("negative input")
    }
    true
}

@Contract[
    requires throwingPredicate(x)
]
func requireBusinessPredicate(x: Int64): Int64 {
    x
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        globalThreshold = 3
        requiresSideEffectCount = 0
        requiresBodyCount = 0
    }

    @AfterEach
    func tearDown(): Unit {
        globalThreshold = 3
        requiresSideEffectCount = 0
        requiresBodyCount = 0
    }

    // CT-REQ-001: `requires x > 0` holds for x = 1; the call executes normally
    // and no contract exception is thrown.
    @TestCase
    func testReq001RequiresHolds() {
        @Expect(requirePositive(1), 1)
    }

    // CT-REQ-002: the same precondition fails for x = 0; a
    // ContractCheckRequiresException is thrown.
    @TestCase
    func testReq002RequiresViolated() {
        var caught = false
        try {
            requirePositive(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(e.message.contains("requires x > 0"), true)
        }
        @Expect(caught, true)
    }

    // CT-REQ-003: two preconditions, both hold; the function executes normally.
    @TestCase
    func testReq003TwoRequiresHold() {
        @Expect(requireInRange(1), 1)
        @Expect(requireInRange(50), 50)
        @Expect(requireInRange(99), 99)
    }

    // CT-REQ-004: the first precondition fails while the second one carries a
    // side effect and the body carries a counter. The contract exception is
    // thrown, the second clause is not evaluated and the body does not run.
    // The control call with x = 1 proves both probes do fire when the first
    // clause holds.
    @TestCase
    func testReq004ShortCircuitOnFirstFailure() {
        requiresSideEffectCount = 0
        requiresBodyCount = 0

        var caught = false
        try {
            requireFirstFailsSecondSideEffect(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(requiresSideEffectCount, 0)
        @Expect(requiresBodyCount, 0)

        requireFirstFailsSecondSideEffect(1)
        @Expect(requiresSideEffectCount, 1)
        @Expect(requiresBodyCount, 1)
    }

    // CT-REQ-005: all four preconditions resolve to the corresponding symbols
    // and take part in the check. Each clause is violated in isolation.
    @TestCase
    func testReq005SymbolResolution() {
        let scope = SymbolScope()

        // All four clauses resolve and hold.
        globalThreshold = 3
        scope.memberFloor = 1
        scope.check(1, 5)

        // Parameter clause `x > 0` violated.
        var caught = false
        try {
            scope.check(0, 5)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)

        // Package-level variable clause `y >= globalThreshold` violated.
        globalThreshold = 6
        caught = false
        try {
            scope.check(1, 5)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        globalThreshold = 3

        // Member variable clause `y >= memberFloor` violated.
        scope.memberFloor = 6
        caught = false
        try {
            scope.check(1, 5)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        scope.memberFloor = 1

        // Function-level auxiliary variable clause `y > localLimit`
        // (localLimit = 4) violated.
        caught = false
        try {
            scope.check(1, 4)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-REQ-006: a local variable in the body shadows the parameter / member
    // variable with the same name. `requires` keeps resolving to the parameter
    // / member and is not affected by the local.
    @TestCase
    func testReq006LocalShadowing() {
        // Parameter `x = 1` satisfies `x > 0` even though the body declares a
        // local `x = -1`; the returned value shows the local is what the body
        // actually used.
        @Expect(shadowedParamInBody(1), -1)
        var caught = false
        try {
            shadowedParamInBody(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)

        // Member `limit = 5` satisfies `limit > 0` although the body declares a
        // local `limit = -1`.
        let scope = MemberShadowScope()
        @Expect(scope.shadowedMemberInBody(), -1)

        // Changing the member to -1 makes the precondition fail: `requires`
        // reads the member, not the same-named local.
        scope.limit = -1
        caught = false
        try {
            scope.shadowedMemberInBody()
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-REQ-007: `requires false` always fails. The contract exception is
    // thrown and the body side-effect probe stays at zero, i.e. the body never
    // executes.
    @TestCase
    func testReq007BodyNotExecuted() {
        let probe = BodyProbe()
        var caught = false
        try {
            rejectAlways(probe)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(probe.count, 0)
    }

    // CT-REQ-008: the `[r1]` name on a precondition does not affect the
    // judgement; valid input passes and invalid input throws the same contract
    // exception as an unnamed clause.
    @TestCase
    func testReq008NamedRequires() {
        @Expect(requireNamedPositive(1), 1)

        var caught = false
        try {
            requireNamedPositive(0)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(e.message.contains("x > 0"), true)
        }
        @Expect(caught, true)
    }

    // CT-REQ-009: the precondition calls the pure function `isEven(x)`; the
    // returned Bool participates in the judgement.
    @TestCase
    func testReq009PureFunctionInRequires() {
        @Expect(requireEven(2), 2)
        @Expect(requireEven(0), 0)

        var caught = false
        try {
            requireEven(3)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }

    // CT-REQ-010: a business exception thrown while evaluating a precondition
    // propagates unchanged instead of being wrapped into a contract exception.
    // Deviation note (DT design doc 20/R7): this behaviour is not specified by
    // design 3.2.1 and is asserted against the current implementation.
    @TestCase
    func testReq010BusinessExceptionPropagates() {
        var caught = false
        try {
            requireBusinessPredicate(-1)
        } catch (e: BusinessException) {
            caught = true
            @Expect(e.message, "negative input")
            @Expect(isContractException(e), false)
        }
        @Expect(caught, true)

        // For valid input the predicate is evaluated normally.
        @Expect(requireBusinessPredicate(1), 1)

        // The contract-evaluation depth was restored by the try/finally around
        // the predicate, so a later contract failure is still reported.
        var contractCaught = false
        try {
            requirePositive(0)
        } catch (e: ContractCheckRequiresException) {
            contractCaught = true
        }
        @Expect(contractCaught, true)
    }
}
