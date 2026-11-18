/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-017: a standalone `count++` statement on its own line after
// `count = count + 1` inside one `@ghost` block used to be misreported as
// "only works as a standalone statement" (audit report 2 #23). Both forms are
// accepted and both increments must be visible to the real body.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [variable count: Int64 = 0]
func varGhostIncrement(): Int64 {
    @ghost (
        count = count + 1
        count++
    )
    return count
}

main() {
    if (varGhostIncrement() != 2) {
        throw Exception("ghost increments were not both applied")
    }
    println("ok")
}
