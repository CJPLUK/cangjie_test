/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-055: every binding form that can shadow a function-level
// contract variable must be detected: `let`, `var`, `for-in`, destructuring,
// nested functions, lambdas, `match` cases and `catch` parameters.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan is shadowed by a local declaration
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [variable x: Int64 = 0]
func covShadowLet(): Int64 {
    let x = 1
    x
}

@Contract [variable x: Int64 = 0]
func covShadowVar(): Int64 {
    var x = 1
    x
}

@Contract [variable x: Int64 = 0]
func covShadowFor(xs: Array<Int64>): Int64 {
    var s = 0
    for (x in xs) {
        s += x
    }
    s
}

@Contract [variable x: Int64 = 0]
func covShadowDestructure(): Int64 {
    let (x, y) = (1, 2)
    x + y
}

@Contract [variable x: Int64 = 0]
func covShadowNestedFunc(): Int64 {
    func x(p: Int64): Int64 {
        p
    }
    x(1)
}

@Contract [variable x: Int64 = 0]
func covShadowLambda(): Int64 {
    let lam = { x: Int64 => x + 1 }
    lam(1)
}

@Contract [variable x: Int64 = 0]
func covShadowMatch(n: Int64): Int64 {
    match (n) {
        case x => x
    }
}

@Contract [variable x: Int64 = 0]
func covShadowCatch(): Int64 {
    try {
        throw Exception("e")
    } catch (x: Exception) {
        x.message.size
    }
}

main() {
}
