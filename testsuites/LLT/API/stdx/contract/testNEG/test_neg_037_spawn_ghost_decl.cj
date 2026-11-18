/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-037: a `@ghost` gate nested inside a `spawn` body declares state that the
// collectors used to miss, so a `requires` referencing it failed with the generic
// "undeclared identifier" instead of the dedicated ghost diagnostic (audit 16.24).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `k` is declared in a `@ghost` block and cannot be used by `requires`, `ensures`, or `throws`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class Neg037SpawnGhostDeclaration {
    @Contract[requires k >= 0]
    public func f(x: Int64): Int64 {
        spawn {
            @ghost (
                var k: Int64 = 0
            )
        }
        return x
    }
}

main() {
}
