/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-045: a `const` local with the same name as a contract `variable` used
// to be invisible to the shadowing scanner, so the generated body read the
// auxiliary slot instead of the constant (silent wrong result, audit report 2
// #13B). The scanner must reject the clash with a dedicated diagnostic.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract variable `x` is shadowed by a local declaration; rename one of them
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [variable x: Int64 = 0]
func negConstShadow(): Int64 {
    const x = 5
    return x
}

main() {
    println("unreachable")
}
