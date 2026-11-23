/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-LOOP-016: `@loopInvariant []` with an empty expression list is invalid;
// design 3.2.6.2 requires one or more invariant expressions.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan loopInvariant needs at least one invariant expression
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func loopEmptyInvariant(): Int64 {
    var i = 0
    @loopInvariant[](while (i < 1) {
        i += 1
    })
    i
}

main() {
    loopEmptyInvariant()
}
