/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-VAR-005: a variable declared inside `@ghost` may not be referenced from
// the requires/ensures clauses, which are evaluated outside the body scope.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot be used by
// ASSERT: scan undeclared identifier
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    ensures g == 1
]
func varGhostScopeNeg(): Unit {
    @ghost(let g = 1)
}

main() {
}
