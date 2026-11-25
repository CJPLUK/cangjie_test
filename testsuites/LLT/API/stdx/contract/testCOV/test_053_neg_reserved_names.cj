/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-053: the `_abs_` prefix is reserved for generated contract
// storage and must be rejected for parameters and for local declarations inside
// a contract-bearing body.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `_abs_` prefix is reserved for generated contract storage
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [
    requires true
]
func covReservedParam(_abs_p: Int64): Unit {
}

@Contract [variable x: Int64 = 0]
func covReservedLocal(): Int64 {
    let _abs_local = 1
    _abs_local
}

main() {
}
