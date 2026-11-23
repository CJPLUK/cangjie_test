/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-ENS-009: nested `$pre` is rejected. The macro parser recognizes the inner
// `$pre(...)` and reports a dedicated compile-time diagnostic.
// Deviation (DT design doc 20/R3): the design spells `@pre`, the current
// implementation uses `$pre`.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `$pre` cannot be nested
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    ensures r: $pre($pre(x)) < r
]
func nestedPre(x: Int64): Int64 {
    x
}

main(): Int64 {
    nestedPre(1)
}