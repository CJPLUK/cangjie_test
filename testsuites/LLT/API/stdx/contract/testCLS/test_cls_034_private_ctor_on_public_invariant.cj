/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-034 (audit H3): constructors check every invariant at their exit
// (spec §3.2.4), so a private constructor must not be filtered out by an
// `on_public` invariant: private constructors are the usual "validate then
// construct" path and must not skip the check.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    on_public invariant [positive] value > 0
]
class ClsPrivateCtor {
    var value: Int64 = 1

    private init(flag: Bool) {
        if (flag) {
            value = 0
        }
    }

    static func make(flag: Bool): ClsPrivateCtor {
        ClsPrivateCtor(flag)
    }
}

@Test
class Test {
    @TestCase
    func testCls034PrivateCtorInvariant() {
        var caught = false
        try {
            let _ = ClsPrivateCtor.make(true)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(ClsPrivateCtor.make(false).value, 1)
    }
}
