/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-023: member-level selective inheritance of every clause kind
// (requires/ensures/throws/variable), a renamed `variable`, a variable without
// an initializer, an unlabeled parent clause skipped while matching, parameter
// renaming inside string interpolation when the condition also reads `$pre`,
// and own clauses appended next to inherited ones.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract []
open class SelectBase {
    public init() {}

    @Contract [
        variable quota: Int64 = 4
        variable slot: Int64 = 7
        variable pending: Int64
        requires x > 0
        requires [bounded] x < quota
        ensures [shape] r: r == "${x}" && $pre(x) <= x
        throws [guard] IllegalArgumentException if x < -1
    ]
    public open func render(x: Int64): String {
        @ghost ( pending = x )
        "${x}"
    }
}

@Contract []
class SelectChild <: SelectBase {
    public init() {}

    @Contract [
        inherits variable SelectBase.quota
        inherits variable SelectBase.pending
        inherits requires bounded = SelectBase.bounded
        inherits ensures shape = SelectBase.shape
        inherits throws guard = SelectBase.guard
        variable ownVar: Int64 = 1
        ensures [extra] r: r.size > 0 && slot > -1000 && ownVar > 0
        throws [extraGuard] IllegalArgumentException if slot < -100
    ]
    public override func render(slot: Int64): String {
        @ghost ( pending = slot )
        "${slot}"
    }
}

@Test
class Test {
    @TestCase
    func testSelectiveInherit() {
        let c = SelectChild()
        @Expect(c.render(3), "3")
    }
}
