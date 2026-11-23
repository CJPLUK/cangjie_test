/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-ENS-020 (R9): clauses are validated one by one, so only the clause whose
// return name collides with a member is reported.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `ensures` return name `ret` on `compute` collides with a member of the enclosing type
// ASSERT: scan-not ensures` return name `r`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
class EnsMultiClause {
    public var ret: Int64 = 0

    @Contract[
        ensures r: r > 0
        ensures ret: ret > 0
    ]
    public func compute(): Int64 {
        1
    }
}

main() {
}
