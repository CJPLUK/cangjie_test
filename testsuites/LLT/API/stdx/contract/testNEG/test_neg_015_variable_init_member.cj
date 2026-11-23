/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-015: a class-level auxiliary variable initializer may not read
// ordinary members or call member functions.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan may not read ordinary members or call member functions
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable v: Int64 = member
]
class C {
    var member: Int64 = 1
}

main() {
}
