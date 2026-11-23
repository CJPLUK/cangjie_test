/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INV-021: a `return` inside a constructor's `finally` block
// also triggers the exit invariant check. Fixed (defect 16.31; see
// contract-defects-audit.md): the `finally` body used to be skipped by the
// exit-check insertion walk.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [invariant v < 0]
class InvFinallyBox {
    var v: Int64
    init(x: Int64) {
        v = 0
        try {
            v = 5
        } finally {
            if (x == 1) {
                return
            }
        }
    }
}

main() {
    var caught = false
    try {
        InvFinallyBox(1)
    } catch (e: ContractCheckInvariantException) {
        caught = true
    }
    if (!caught) {
        throw Exception("finally-branch return did not trigger the exit invariant check")
    }
    println("ok")
}
