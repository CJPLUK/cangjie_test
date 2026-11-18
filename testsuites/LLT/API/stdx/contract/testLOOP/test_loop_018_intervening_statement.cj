/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-LOOP-018: `@loopInvariant` must be immediately followed by its loop. The
// attribute-style form below inserts a `let` declaration between the macro and
// the loop, which the contract parser rejects.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan contract expression failed to parse: Failed to parse expr fragment.
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func loopInterveningStatement(): Int64 {
    var i = 0
    @loopInvariant[true]
    let x = 1
    while (i < x) {
        i += 1
    }
    i
}

main() {
    loopInterveningStatement()
}
