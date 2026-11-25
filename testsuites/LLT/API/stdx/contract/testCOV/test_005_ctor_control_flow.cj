/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-005: the instance invariant check must be injected before every
// constructor exit, including exits nested in if/else-if, loops, match,
// try/catch/finally and `unsafe` blocks, and in primary constructors.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    invariant [positive] value > 0
]
class CovCtorFlow {
    var value: Int64 = 1

    init(mode: Int64) {
        if (mode == 0) {
            while (true) {
                value = 0
                return
            }
        }
        if (mode == 1) {
            do {
                value = 0
                return
            } while (false)
        }
        if (mode == 2) {
            for (i in 0..3) {
                value = 0
                return
            }
        }
        if (mode == 3) {
            match (mode) {
                case 3 => value = 0
                case _ => ()
            }
            return
        }
        if (mode == 4) {
            try {
                value = 0
                return
            } catch (e: Exception) {
                value = 0
                return
            } finally {
                if (value < -100) {
                    println("finally")
                }
            }
        }
        if (mode == 5) {
            unsafe {
                value = 0
                return
            }
        }
        if (mode == 6) {
            if (value > 0) {
                value = 0
                return
            } else {
                return
            }
        }
        if (mode == 7) {
            if (mode > 100) {
                return
            } else if (mode == 7) {
                value = 0
                return
            }
        }
    }
}

@Contract [
    invariant [positive] value > 0
]
class CovCtorPrimary {
    CovCtorPrimary(public let value: Int64) {}
}

@Test
class Test {
    @TestCase
    func testCovCtorFlowViolations() {
        for (mode in 0..=7) {
            var caught = false
            try {
                let _ = CovCtorFlow(mode)
            } catch (e: ContractCheckInvariantException) {
                caught = true
            }
            @Expect(caught, true)
        }
    }

    @TestCase
    func testCovCtorFlowNormal() {
        @Expect(CovCtorFlow(200).value, 1)
    }

    @TestCase
    func testCovCtorPrimary() {
        var caught = false
        try {
            let _ = CovCtorPrimary(0)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(CovCtorPrimary(2).value, 2)
    }
}
