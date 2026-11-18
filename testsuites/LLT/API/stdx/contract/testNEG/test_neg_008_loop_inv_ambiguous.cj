/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-008: trailing tokens after the `@loopInvariant` bracket list make the
// annotation ambiguous and are rejected.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan expected declaration, found
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func f(x: Int64): Unit {
    @loopInvariant[x > 0] + 1
    while (x > 0) {
    }
}

main() {
}
