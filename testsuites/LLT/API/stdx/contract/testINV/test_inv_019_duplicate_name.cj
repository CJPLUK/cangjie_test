/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INV-019: two invariants of the same type may not share a name.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan duplicate invariant name `Inv`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    invariant [Inv] true
    invariant [Inv] true
]
class C {
    public init() {}
}

main() {
}
