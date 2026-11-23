/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-VAR-004 (supplementary negative): design 3.2.6.3 lets a variable declared
// with `let/var` inside a `@ghost` block be used by a later `@ghost`,
// `@contractAssert` or `@loopInvariant`, but the implementation lowers each
// `@ghost` body into its own generated block, so the declaration does not
// escape and the reference is reported as an undeclared identifier. The
// positive in-block usage required by DT doc 20/R12 is covered by CT-VAR-004
// in test_var.cj; this case additionally locks the cross-block visibility
// boundary as the current compile-time behavior.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan undeclared identifier 'ghostLocal'
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func varGhostLocalVisibility(): Int64 {
    @ghost (
        var ghostLocal: Int64 = 3
    )
    @contractAssert(ghostLocal == 3)
    42
}

main() {
}
