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

class Probe {
    var count: Int64 = 0
}

// A function whose precondition never holds; used to observe whether runtime
// contract checking is enabled.
@Contract[
    requires false
]
func rejectAlways(probe: Probe): Unit {
    probe.count += 1
}

// Carries every contract kind listed in design 3.5.1 so that CT-API-010 can
// verify the compile-time switch covers all of them.
// The implementation requires an enclosing type contract for prop contracts, hence
// the empty `@Contract`.
@Contract
class ApiViolating {
    @Contract[
        requires false
    ]
    public func memberViolating(): Unit {
    }

    @Contract[
        get
        requires false
    ]
    public prop value: Int64 {
        get() {
            0
        }
    }
}

// Inner-function contract for CT-API-010.
@Contract
func callInnerViolating(): Unit {
    @Contract[
        requires false
    ]
    func innerViolating(): Unit {
    }
    innerViolating()
}

@Contract
func withContractAssert(): Unit {
    @contractAssert(false)
}

@Contract
func withLoopInvariant(): Unit {
    var i = 0
    @loopInvariant[i < 0](while (i < 1) {
        i += 1
    })
}

// CT-API-013 note: design 3.5.1 defines only a global on/off switch and states
// that per-function/per-type switches do not exist. The current implementation has
// no filter API either, so both functions below are checked when the switch is on.
@Contract[
    requires false
]
func firstNamedContract(): Unit {
}

@Contract[
    requires false
]
func anotherNamedContract(): Unit {
}

// Note: CT-API-003~009, 011 and 012 were removed together with the runtime switch
// APIs setCheckContract()/unsetCheckContract() (design §3.5 change: the switch is
// decided only by the compile-time `--cfg "contract_check=on"`). Disabled-state
// behaviour is covered by the contract_verify cases in the stdx tree.
@Test
class Test {
    // The switch is fixed at compile time (`--cfg "contract_check=on"`); this
    // suite is built with checking on, so no per-case state handling is needed.
    @BeforeEach
    func setUp(): Unit {
    }

    @AfterEach
    func tearDown(): Unit {
    }

    // CT-API-001: the switch is decided at compile time by
    // `--cfg "contract_check=on"`; this suite is built with checking on, so a
    // function with `requires false` throws ContractCheckRequiresException and
    // the function body is not executed.
    @TestCase
    func testApi001CompileTimeEnabled() {
        @Expect(contractCheckEnabled(), true)
        let probe = Probe()
        var caught = false
        try {
            rejectAlways(probe)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(probe.count, 0)
    }

    // CT-API-002: with checking enabled, calling the same function throws
    // ContractCheckRequiresException and the function body is not executed.
    @TestCase
    func testApi002EnableCheck() {
        @Expect(contractCheckEnabled(), true)
        let probe = Probe()
        var caught = false
        try {
            rejectAlways(probe)
        } catch (e: ContractCheckRequiresException) {
            caught = true
            @Expect(e.message.contains("requires false"), true)
        }
        @Expect(caught, true)
        @Expect(probe.count, 0)
    }

    // CT-API-010: with checking enabled, global functions, member functions, inner
    // functions, prop getters, @contractAssert and @loopInvariant are all checked.
    @TestCase
    func testApi010AllChecksEnabled() {
        var globalCaught = false
        try {
            rejectAlways(Probe())
        } catch (e: ContractCheckRequiresException) {
            globalCaught = true
        }
        @Expect(globalCaught, true)

        let target = ApiViolating()
        var memberCaught = false
        try {
            target.memberViolating()
        } catch (e: ContractCheckRequiresException) {
            memberCaught = true
        }
        @Expect(memberCaught, true)

        var innerCaught = false
        try {
            callInnerViolating()
        } catch (e: ContractCheckRequiresException) {
            innerCaught = true
        }
        @Expect(innerCaught, true)

        var propCaught = false
        try {
            @Expect(target.value, 0)
        } catch (e: ContractCheckRequiresException) {
            propCaught = true
        }
        @Expect(propCaught, true)

        var assertCaught = false
        try {
            withContractAssert()
        } catch (e: ContractCheckAssertException) {
            assertCaught = true
        }
        @Expect(assertCaught, true)

        var loopCaught = false
        try {
            withLoopInvariant()
        } catch (e: ContractCheckLoopInvariantException) {
            loopCaught = true
        }
        @Expect(loopCaught, true)
    }

    // CT-API-013: the switch is global; there is no per-function or per-type filter
    // API, so differently named functions are both checked while enabled.
    // Deviation from the design case (see DT design doc 20/R8): filters are not
    // implemented, so the case verifies the global-switch semantics instead.
    @TestCase
    func testApi013NoPerFunctionFilter() {
        var firstCaught = false
        try {
            firstNamedContract()
        } catch (e: ContractCheckRequiresException) {
            firstCaught = true
        }
        @Expect(firstCaught, true)

        var anotherCaught = false
        try {
            anotherNamedContract()
        } catch (e: ContractCheckRequiresException) {
            anotherCaught = true
        }
        @Expect(anotherCaught, true)
    }
}
