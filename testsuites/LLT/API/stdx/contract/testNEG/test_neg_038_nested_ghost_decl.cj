/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-038: an inner `@ghost` nested inside another gate declares state that stays
// visible to the enclosing callable (design L421); the outer gate's declarations alone
// were collected, so a `requires` referencing the inner name produced only the generic
// compiler error instead of the dedicated ghost diagnostic (audit 16.25).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan declared in a `@ghost` block
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class Neg038NestedGhostDeclaration {
    @Contract[requires deep >= 0]
    public func f(x: Int64): Int64 {
        @ghost (
            @ghost (
                var deep: Int64 = 0
            )
        )
        return x
    }
}

main() {
}
