/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-015: a constructor-body local declared before a `@ghost` block legally
// shadows the same-named type-level auxiliary variable; the `@ghost` block
// operates on the local. Fixed (audit report 3, omission 2): the validation
// used to report a false `is read in @ghost before it is initialized` because
// only locals declared inside the ghost block were considered shadowing.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [
    variable x: Int64
]
class CtorOuterLocal {
    init() {
        var x = 42
        @ghost(
            x = x + 1
        )
        if (x != 43) {
            throw Exception("constructor local was not updated by the ghost block")
        }
    }
}

main() {
    let _ = CtorOuterLocal()
    println("ok")
}
