/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-009: function-level contract `variable` access from ordinary body
// statements. Deviation (DT design doc 15, CT-NEG-009): the design expects a
// compile error, the implementation exposes the variable to the body and only
// reports unused-variable warnings for the contract-side snapshot.
// EXEC-PIPE-0: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan unused variable
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable v: Int64 = 0
]
func f(): Unit {
    v = 1
}

main() {
}
