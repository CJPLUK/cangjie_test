/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-011: `ensures` may not reference a variable declared inside the
// function body.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan undeclared identifier
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    ensures localValue > 0
]
func f(x: Int64): Int64 {
    let localValue = x
    localValue
}

main() {
}
