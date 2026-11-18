/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-006: `@ghost` blocks in a static member function or `static init` may
// not access instance auxiliary variables.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan instance auxiliary variable `stored` cannot be accessed from a static context
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable stored: Int64 = 1
]
class C {
    public init() {}

    public static func readStatic(): Unit {
        @ghost(
            let value = stored
        )
    }
}

main() {
}
