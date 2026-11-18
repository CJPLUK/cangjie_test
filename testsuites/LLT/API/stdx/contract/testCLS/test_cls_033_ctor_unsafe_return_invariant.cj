/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-033 (audit H2): `unsafe { ... }` parses as a plain block expression;
// a `return` inside it leaves the constructor and must run the invariant check
// just like any other exit.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    on_public invariant [positive] value > 0
]
class ClsUnsafeReturnCtor {
    var value: Int64 = 1

    init(flag: Bool) {
        if (flag) {
            unsafe {
                value = 0
                return
            }
        }
    }
}

@Test
class Test {
    @TestCase
    func testCls033UnsafeReturnInvariant() {
        var caught = false
        try {
            let _ = ClsUnsafeReturnCtor(true)
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(ClsUnsafeReturnCtor(false).value, 1)
    }
}
