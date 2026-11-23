/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-029: §3.1.7 — contracts are not supported on foreign functions.
// The macro must report a targeted diagnostic instead of crashing while
// reconstructing the foreign FuncDecl (ASTException).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contracts are not supported on foreign functions
// ASSERT: scan-not macro evaluation has failed
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    requires x > 0
]
foreign func neg029Foreign(x: Int64): Int64

main() {
}
