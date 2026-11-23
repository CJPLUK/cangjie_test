/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-NEG-027: positive control for CT-NEG-018 (R2). `invariant` is a contextual
// keyword; an auxiliary variable with that name is legal and its use inside the
// invariant clause is disambiguated with parentheses.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

@Contract[
    variable invariant: Bool = true
    invariant (invariant)
]
class Pos27 {
    @Contract
    func breakIt(): Unit {
        @ghost(invariant = false)
    }
}

@Test
class Test {
    @TestCase
    func testInvariantKeywordVariable() {
        let o = Pos27()
        var caught = false
        try {
            o.breakIt()
        } catch (e: ContractCheckInvariantException) {
            caught = true
        }
        @Expect(caught, true)
    }
}
