/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-013: a class-level invariant may not share its name with an auxiliary
// variable. With the same name the invariant expression resolves to the Int64
// auxiliary variable and fails to compile as a Bool condition.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid unary operator
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable v: Int64 = 0
    invariant v
]
class C {
}

main() {
}
