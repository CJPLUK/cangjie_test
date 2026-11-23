/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-036: `$pre` snapshots exist for the clauses of a callable contract only.
// `@contractAssert` / `@loopInvariant` used to fail with the SDK's generic parse
// error; the parser now reports the dedicated diagnostic (audit 16.23).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan only available in contract clauses
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class Neg036PreInAssert {
    private var v: Int64 = 0

    func f(x: Int64): Int64 {
        @contractAssert($pre(v) >= 0)
        return x
    }
}

main() {
}
