/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-012: a constructor `@ghost` block may not call member functions.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan member function calls are not allowed in `@ghost` blocks of constructors
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable a: Int64 = 0
]
class C {
    func helper(): Int64 {
        1
    }

    public init() {
        @ghost(
            a = helper()
        )
    }
}

main() {
}
