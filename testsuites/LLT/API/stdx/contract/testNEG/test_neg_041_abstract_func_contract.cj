/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-NEG-041 (EXEC-PIPE-1): `@Contract` directly annotating a bodyless interface
// function reports the dedicated diagnostic. Fixed (defect 16.29; see
// contract-defects-audit.md): the macro used to fail with a generic expansion
// error instead of pointing at the missing body.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot annotate a function without a body
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

interface Neg041AbstractFunc {
    @Contract [requires x > 0]
    func f(x: Int64): Unit
}

main() {
}
