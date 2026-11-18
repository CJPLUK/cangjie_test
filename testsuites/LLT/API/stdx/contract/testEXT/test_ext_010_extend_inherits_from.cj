/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-EXT-010 (audit H8): spec §3.4.5 allows `@Contract[inherits from I]` on
// `extend A <: I` so the extension method reuses the interface contracts; the
// type-level validator used to reject it unconditionally.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract[]
interface ExtInheritIface {
    @Contract [
        requires x > 0
    ]
    func extInheritF(x: Int64): Int64
}

class ExtInheritHost {}

@Contract [
    inherits from ExtInheritIface
]
extend ExtInheritHost <: ExtInheritIface {
    public func extInheritF(x: Int64): Int64 {
        x
    }
}

@Test
class Test {
    @TestCase
    func testExt010ExtendInheritsFrom() {
        var caught = false
        try {
            ExtInheritHost().extInheritF(-1)
        } catch (e: ContractCheckRequiresException) {
            caught = true
        }
        @Expect(caught, true)
        @Expect(ExtInheritHost().extInheritF(3), 3)
    }
}
