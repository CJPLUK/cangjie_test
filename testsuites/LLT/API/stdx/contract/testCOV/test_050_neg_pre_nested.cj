/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-050: `$pre` snapshots must reject nesting.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot be nested
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [
    ensures r: $pre($pre(1)) > 0
]
func covPreNested(): Int64 {
    1
}

main() {
}
