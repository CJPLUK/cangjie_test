/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-VAR-011: a named-argument label matching a ghost `variable`
// name is not rewritten. Fixed (defect 16.30; see contract-defects-audit.md):
// the aux-variable rewrite used to replace the `x` label of `g(x: 5)` with a
// ghost read, corrupting the call.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

func g(x!: Int64): Int64 {
    return x
}

@Contract [variable x: Int64 = 0]
func labelCall(): Int64 {
    return g(x: 5)
}

main() {
    if (labelCall() != 5) {
        throw Exception("named-argument label was corrupted by the ghost rewrite")
    }
    println("ok")
}
