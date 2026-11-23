/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-010: design expects a compile error when an ordinary body statement
// reads/writes a function-level auxiliary variable. The implementation allows
// it: the body assignment reaches the contract-side variable (the `ensures`
// below passes). Landed as a compile-positive control (R-VAR-2).
// EXEC-PIPE-0: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable w: Int64 = 0
    ensures w == 1
]
func varBodyWrite(): Unit {
    w = 1
}

main() {
    varBodyWrite()
}
