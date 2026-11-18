/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-035 (audit H4): a constructor's `$pre` may reference a function-level
// auxiliary variable. The snapshot used to be wrapped in a closure capturing the
// mutable helper local, which the compiler rejects; it is now bound with a plain
// `let`, consistent with the non-constructor path.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract[]
class ClsCtorPreAux {
    var value: Int64

    @Contract [
        variable count: Int64 = 0
        ensures count == $pre(count)
    ]
    init() {
        value = 1
    }
}

@Test
class Test {
    @TestCase
    func testCls035CtorPreAuxVariable() {
        @Expect(ClsCtorPreAux().value, 1)
    }
}
