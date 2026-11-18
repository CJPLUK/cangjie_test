/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-046: a nested local function whose name or parameter matches a
// contract `variable` used to escape the shadowing scanner, so the rewritten
// body silently evaluated the auxiliary slot inside the local function (audit
// report 2 #13A). The scanner must reject the clash with a dedicated
// diagnostic.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract variable `x` is shadowed by a local declaration; rename one of them
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [variable x: Int64 = 0]
func negNestedFuncShadow(): Int64 {
    func g(x: Int64): Int64 { x + 1 }
    return g(5)
}

main() {
    println("unreachable")
}
