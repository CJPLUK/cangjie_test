/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-LOOP-008: `while`/`do-while` invariants may not reference a for-loop
// variable. Only a for-in invariant brings the loop variable into scope; the
// names `j` and `k` below are never declared, so the compiler reports
// undeclared identifiers.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan undeclared identifier 'j'
// ASSERT: scan undeclared identifier 'k'
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
func loopWhileUndefinedVariable(): Unit {
    var i = 0
    @loopInvariant[j >= 0](while (i < 1) {
        i += 1
    })
}

@Contract
func loopDoWhileUndefinedVariable(): Unit {
    @loopInvariant[k > 0](do {
    } while (k < 1))
}

main() {
    loopWhileUndefinedVariable()
    loopDoWhileUndefinedVariable()
}
