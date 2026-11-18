/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-020 (audit M2): an instance auxiliary-variable initializer may read an
// earlier `static` auxiliary variable. The initializer used to read the static
// storage directly, before its lazy initialization, and threw
// ContractCheckGhostStateException; it now goes through the property accessor.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    static variable base: Int64 = 5
    variable derived: Int64 = base + 1
    invariant [consistent] derived == 6
]
class VarStaticInit {
    init() {}
}

@Test
class Test {
    @TestCase
    func testVar020InstanceInitReadsStatic() {
        var ghost = false
        try {
            let _ = VarStaticInit()
        } catch (e: ContractCheckGhostStateException) {
            ghost = true
        }
        @Expect(ghost, false)
    }
}
