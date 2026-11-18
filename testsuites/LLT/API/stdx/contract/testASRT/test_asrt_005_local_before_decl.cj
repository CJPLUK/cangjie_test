/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-ASRT-005: an assertion may not reference a local variable that is
// declared after the assertion.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan undeclared identifier
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func asrtLaterDecl(x: Int64): Unit {
    @contractAssert(later == x)
    let later = x
}

main() {
}
