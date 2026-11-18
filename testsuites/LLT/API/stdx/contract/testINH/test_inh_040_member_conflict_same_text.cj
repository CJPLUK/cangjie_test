/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-040: two unrelated parents declare the same contract name on the same
// member with identical text; inheriting both is still a same-kind name
// conflict (design v2 §3.4.2). A shared ancestor reached through two paths
// (diamond) must not trigger the diagnostic, only independent declarations do.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited contracts for `f(Int64)` both declare contract `pos`; rename one with `=`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
interface InhNeg040A {
    @Contract[
        requires [pos] x > 0
    ]
    public func f(x: Int64): Int64
}

@Contract
interface InhNeg040B {
    @Contract[
        requires [pos] x > 0
    ]
    public func f(x: Int64): Int64
}

@Contract[
    inherits from InhNeg040A
    inherits from InhNeg040B
]
class InhNeg040Impl <: InhNeg040A & InhNeg040B {
    public func f(x: Int64): Int64 {
        x
    }
}

main() {
}
