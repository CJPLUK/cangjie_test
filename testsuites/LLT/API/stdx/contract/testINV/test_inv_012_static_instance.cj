/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INV-012: a `static invariant` may not read an instance auxiliary variable.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan instance auxiliary variable `x` cannot be accessed from a `static invariant`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable x: Int64 = 1
    static invariant [SI] x > 0
]
class C {
    public init() {}
}

main() {
}
