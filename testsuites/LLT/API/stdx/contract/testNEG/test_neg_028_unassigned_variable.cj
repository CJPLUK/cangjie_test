/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-028: design L527 requires an instance auxiliary variable without an
// initial value to be assigned in a constructor `@ghost` block, and a `static`
// one in a `static init` `@ghost` block. A variable that no constructor ever
// assigns is reported at compile time (runtime would only fail later with
// ContractCheckGhostStateException on first read).
// EXEC-PIPE-0: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan auxiliary variable `pending` has no initial value and is never assigned in a constructor `@ghost` block
// ASSERT: scan static auxiliary variable `stamp` has no initial value and is never assigned in a `static init` `@ghost` block
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable pending: Int64
    static variable stamp: Int64
]
class NegVar028Unassigned {
    public init() {}
}

main() {
    // The diagnostics are compile-time; instantiation is not required here.
}
