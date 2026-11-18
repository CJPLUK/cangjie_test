/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-009: a `[conforming]` override may not strengthen the parent's
// precondition.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `[conforming]` override of `work(Int64)` cannot add a `requires` contract
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
open class InhNeg009Base {
    public var amount: Int64 = 0

    public init() {}

    @Contract[
        requires amount >= 0
    ]
    public open func work(delta: Int64): Unit {
        amount += delta
    }
}

@Contract[
    inherits from InhNeg009Base [conforming]
]
class InhNeg009Sub <: InhNeg009Base {
    public init() {
        super()
    }

    @Contract[
        requires delta > 0
    ]
    public override func work(delta: Int64): Unit {
        amount += delta
    }
}

main() {
}
