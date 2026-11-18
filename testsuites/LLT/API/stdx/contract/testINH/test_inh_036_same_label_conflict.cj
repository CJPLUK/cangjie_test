/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-036: the override redeclares the parent's labelled clause `pos` with
// different content.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan override of `work(Int64)` both declare contract `pos`; rename one with `=`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
open class InhNeg036Base {
    public init() {}

    @Contract[
        requires [pos] x > 0
    ]
    public open func work(x: Int64): Int64 {
        x
    }
}

@Contract
class InhNeg036Sub <: InhNeg036Base {
    public init() {
        super()
    }

    @Contract[
        requires [pos] x > 10
    ]
    public override func work(x: Int64): Int64 {
        x
    }
}

main() {
}
