/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-016: identifiers inside string interpolation must participate in the
// auxiliary-variable rewrite. With a global `total` in scope the rewritten
// condition used to read the global (100, `${total}`.size == 3) instead of the
// auxiliary slot, so the contract silently checked the wrong value (audit
// report 2 #12C; `${total}` in the ensure is the aux slot read).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

let total = 100

@Contract [
    variable total: Int64 = 1
    ensures r: "${total}".size == 1
]
func varInterpAux(): Int64 { 0 }

main() {
    if (varInterpAux() != 0) {
        throw Exception("body did not run")
    }
    println("ok")
}
