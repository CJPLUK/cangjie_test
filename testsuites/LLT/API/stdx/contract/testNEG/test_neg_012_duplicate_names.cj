/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-012: a name used by a contract `variable` may not be reused as the
// `ensures` return name in the same function.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan collides with contract variable name
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable v: Int64 = 0
    ensures v: v > 0
]
func f(): Int64 {
    1
}

main() {
}
