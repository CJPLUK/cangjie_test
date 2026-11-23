/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-011: a constructor `@ghost` block may not read an auxiliary variable
// that has not been initialized yet.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan auxiliary variable `a` is read in `@ghost` before it is initialized
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable a: Int64
    variable b: Int64 = 2
]
class C {
    public init() {
        @ghost(
            b = a + 1
        )
    }
}

main() {
}
