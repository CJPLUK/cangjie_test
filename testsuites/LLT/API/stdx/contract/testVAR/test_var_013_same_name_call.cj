/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-VAR-013: a zero-argument call whose callee name matches a
// ghost `variable` name is not rewritten. Fixed (defect 16.30; see
// contract-defects-audit.md): `g()` used to be rewritten into a ghost read.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func g(): Int64 {
    return 7
}

@Contract [variable g: Int64 = 0]
func callAux(): Int64 {
    return g()
}

main() {
    if (callAux() != 7) {
        throw Exception("zero-argument call was rewritten into a ghost read")
    }
    println("ok")
}
