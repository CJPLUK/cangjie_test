/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INV-020: constructor invariant checks also cover early
// returns inside `match` branches. Fixed (defect 16.31; see
// contract-defects-audit.md): a `return` in a match case used to bypass the
// generated exit invariant check.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [invariant v < 0]
class InvMatchBox {
    var v: Int64
    init(x: Int64) {
        v = x
        match (x) {
            case 1 => return
            case _ => ()
        }
    }
}

@Contract [invariant v < 0]
class InvIfBox {
    var v: Int64
    init(x: Int64) {
        v = x
        if (x == 1) {
            return
        }
    }
}

main() {
    var matchCaught = false
    try {
        InvMatchBox(1)
    } catch (e: ContractCheckInvariantException) {
        matchCaught = true
    }
    if (!matchCaught) {
        throw Exception("match-branch return did not trigger the exit invariant check")
    }
    var ifCaught = false
    try {
        InvIfBox(1)
    } catch (e: ContractCheckInvariantException) {
        ifCaught = true
    }
    if (!ifCaught) {
        throw Exception("if-branch return did not trigger the exit invariant check")
    }
    println("ok")
}
