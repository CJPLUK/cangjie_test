/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INV-023: statements after a user-written `try/catch` in a
// constructor keep the exit invariant check. Fixed (defect 16.32; see
// contract-defects-audit.md): the user `try` used to shadow the generated
// wrapper and suppress the check.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [invariant v < 0]
class InvUserTryMidBox {
    var v: Int64
    init(x: Int64) {
        v = -1
        try {
            v = x
        } catch (e: Exception) {
            v = -1
        }
        v = 5
    }
}

main() {
    var caught = false
    try {
        InvUserTryMidBox(1)
    } catch (e: ContractCheckInvariantException) {
        caught = true
    }
    if (!caught) {
        throw Exception("exit invariant check was suppressed by the user try/catch")
    }
    println("ok")
}
