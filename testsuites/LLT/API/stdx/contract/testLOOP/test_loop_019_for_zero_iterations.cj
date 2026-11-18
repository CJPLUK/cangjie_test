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

// CT-LOOP-019: a `for-in` loop that iterates zero times.
//
// Per DT doc 20/R6 (calibrated): the for-in check point is "the start of every
// iteration" (design 3.2.6.2), so an empty range performs zero checks.
var loopZeroForChecks: Int64 = 0

func loopZeroForTick(): Bool {
    loopZeroForChecks += 1
    true
}

@Contract
func loopForZero(): Int64 {
    var sum = 0
    @loopInvariant[loopZeroForTick()](for (i in 0..0) {
        sum += i
    })
    sum
}

@Test
class Test {
    @BeforeEach
    func setUp(): Unit {
        loopZeroForChecks = 0
    }

    @AfterEach
    func tearDown(): Unit {
        loopZeroForChecks = 0
    }

    // CT-LOOP-019: the loop body never runs, so no invariant check is
    // performed (0 checks, per the R6-calibrated expectation).
    @TestCase
    func testLoop019ForZeroIterations() {
        @Expect(loopForZero(), 0)
        @Expect(loopZeroForChecks, 0)
    }
}
