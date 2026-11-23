/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-047: a `catch` binding with the same name as a contract `variable`
// used to escape the shadowing scanner, so the rewritten body replaced the
// exception reference with the auxiliary slot (audit report 2 #14). The
// scanner must reject the clash with a dedicated diagnostic.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract variable `ex` is shadowed by a local declaration; rename one of them
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable ex: Exception = Exception("aux")
    ensures r: true
]
func negCatchShadow(): Int64 {
    try {
        throw Exception("boom")
    } catch (ex: Exception) {
        println(ex.message)
    }
    return 0
}

main() {
    println("unreachable")
}
