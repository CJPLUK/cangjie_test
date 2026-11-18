/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-008: a class-level auxiliary variable initializer may only reference
// earlier auxiliary variables that already have initial values.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan abstract variable initializer may only reference earlier abstract variables with initial values: `b`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable a: Int64 = b
    variable b: Int64 = 1
]
class C {
    public init() {}
}

main() {
}
