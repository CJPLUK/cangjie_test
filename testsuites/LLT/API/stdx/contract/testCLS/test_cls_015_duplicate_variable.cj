/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-015: auxiliary variable names must be unique within one type contract.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan duplicate abstract variable name `x`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable x: Int64 = 1
    variable x: Int64 = 2
]
class C {
    public init() {}
}

main() {
}
