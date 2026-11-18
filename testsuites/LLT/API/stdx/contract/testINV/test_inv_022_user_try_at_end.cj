/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INV-022: a user-written `try/catch` at the end of a
// constructor body is not mistaken for the generated invariant wrapper, so the
// exit invariant check is still inserted. Fixed (defect 16.32; see
// contract-defects-audit.md): the check used to be dropped and the invariant
// never fired.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [invariant v < 0]
class InvUserTryBox {
    var v: Int64
    init(x: Int64) {
        v = -1
        try {
            if (x == 1) {
                throw Exception("boom")
            }
        } catch (e: Exception) {
            v = 1
        }
    }
}

main() {
    var caught = false
    try {
        InvUserTryBox(1)
    } catch (e: ContractCheckInvariantException) {
        caught = true
    }
    if (!caught) {
        throw Exception("exit invariant check was suppressed by the user try/catch")
    }
    println("ok")
}
