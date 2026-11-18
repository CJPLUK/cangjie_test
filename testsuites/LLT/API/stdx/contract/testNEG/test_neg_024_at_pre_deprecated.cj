/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-024: the deprecated `@pre` spelling is rejected (R3: use `$pre`);
// nested `@` macro calls are not supported inside contract attributes.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan illegal attribute tokens in macro call
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    ensures @pre(x) == x
]
func f(x: Int64): Int64 {
    x
}

main() {
}
