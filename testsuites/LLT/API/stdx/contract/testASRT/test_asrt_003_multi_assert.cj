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

// CT-ASRT-003: one `@contractAssert` carries several assertions, separated by
// newlines as specified by design 3.2.6.1 (`@contractAssert(<expr>+)`). The
// expressions are evaluated in order; when the first one is false a
// ContractCheckAssertException is thrown and the second one, which carries a
// side effect, is not evaluated.
var asrtSideEffectCount: Int64 = 0

func asrtSideEffectTrue(): Bool {
    asrtSideEffectCount += 1
    true
}

@Contract
func asrtSequence(firstFails: Bool): Unit {
    @contractAssert(
        !firstFails
        asrtSideEffectTrue()
    )
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        asrtSideEffectCount = 0
    }

    @AfterEach
    func tearDown(): Unit {
        asrtSideEffectCount = 0
    }

    // CT-ASRT-003: the first assertion fails, so the exception is thrown and
    // the second, side-effecting assertion is not evaluated. The control call
    // proves the second assertion fires when the first one holds.
    @TestCase
    func testAsrt003ShortCircuitOnFirstFailure() {
        asrtSideEffectCount = 0
        var caught = false
        try {
            asrtSequence(true)
        } catch (e: ContractCheckAssertException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(asrtSideEffectCount, 0)

        asrtSequence(false)
        @Expect(asrtSideEffectCount, 1)
    }
}
