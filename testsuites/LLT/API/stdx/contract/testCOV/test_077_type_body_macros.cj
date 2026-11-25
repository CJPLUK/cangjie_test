/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-077: a type contract whose members carry in-body contract macros
// (@ghost / @contractAssert / @loopInvariant), a static prop, and bodies with
// top-level `return` plus auxiliary-variable updates exercise the type-level
// body scanning.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable total: Int64 = 0
    invariant total >= 0
]
class CovTypeBody {
    public static prop sp: Int64 {
        get() {
            1
        }
    }

    public init() {}

    public func work(n: Int64): Int64 {
        @ghost ( total += 1 )
        @contractAssert ( total > 0 )
        @loopInvariant[total >= 0](for (i in 0..n) {
            ()
        })
        if (n < 0) {
            return 0
        }
        n
    }

    public func spin(n: Int64): Int64 {
        var i = 0
        @loopInvariant[i >= 0 && i <= n](do {
            i += 1
        } while (i < n))
        i
    }
}

@Test
class Test {
    @TestCase
    func testTypeBodyMacros() {
        let c = CovTypeBody()
        @Expect(c.work(2), 2)
        @Expect(c.spin(3), 3)
        @Expect(CovTypeBody.sp, 1)
    }
}
