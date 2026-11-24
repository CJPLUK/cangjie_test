/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-042: the `@contractAssert` expression-list reader must reject an
// outer parenthesis wrapping several expressions, an expression followed by a
// token that is neither a newline nor `;`, and a parenthesized expression
// followed by a stray token.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan the outer parentheses are not supported
// ASSERT: scan expected a newline or
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

func covExprGrouped(x: Int64, y: Int64): Int64 {
    @contractAssert((x > 0; y > 0))
    x + y
}

func covExprAdjacent(x: Int64): Int64 {
    @contractAssert(x > 0 x < 10)
    x
}

func covExprParenThenStray(x: Int64): Int64 {
    @contractAssert((x > 0) x)
    x
}

main() {
}
