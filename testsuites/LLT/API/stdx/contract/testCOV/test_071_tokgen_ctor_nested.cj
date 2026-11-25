/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-071: a constructor that has its own declaration-level contract
// inside a type-level contract. The type invariant injection walks the generated
// wrapper body, so exits nested in an `unsafe` block and in a `try ... finally`
// must also receive the invariant checks.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    invariant v >= 0
]
class CovTokCtorNested {
    public var v: Int64 = 0

    @Contract [
        ensures v >= 0
    ]
    public init(mode: Int64) {
        unsafe {
            v = 5
        }
        if (mode == 1) {
            v = v + 1
        }
        try {
            v = v + 1
        } catch (e: Exception) {
            v = 0
        } finally {
            v = v + 1
        }
    }
}

@Test
class Test {
    @TestCase
    func testCtorNestedInvariants() {
        let a = CovTokCtorNested(1)
        @Expect(a.v, 8)
        let b = CovTokCtorNested(2)
        @Expect(b.v, 7)
    }
}
