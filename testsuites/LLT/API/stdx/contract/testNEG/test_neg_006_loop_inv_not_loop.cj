/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-006: `@loopInvariant` must directly precede its loop; a non-loop
// statement after the annotation fails to attach and is rejected.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract expression failed to parse
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func f(): Unit {
    @loopInvariant[true]
    let notALoop = 1
}

main() {
}
