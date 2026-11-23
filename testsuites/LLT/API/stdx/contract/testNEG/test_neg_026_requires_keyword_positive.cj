/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-NEG-026: positive control for CT-NEG-017 (R2). `requires` is a contextual
// keyword; a parameter with that name is legal and, when referenced inside a
// contract expression, is disambiguated with parentheses.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

@Contract[
    requires ((requires) > 0)
]
func checked(requires: Int64): Int64 {
    requires
}

@Test
class Test {
    @TestCase
    func testRequiresKeywordVariable() {
        @Expect(checked(5), 5)
        var caught = false
        try {
            checked(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
