/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-041: a function-level `inherits` clause must resolve against the
// contract of the member carrying the clause. Matching a contract from a
// different-signature overload is rejected (design v2 §3.4.1).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan no inherited contract matches the requested kind and name: `InhNeg041Base.r`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
open class InhNeg041Base {
    public init() {}

    @Contract[
        requires [r] x > 0
    ]
    public open func f(x: Int64): Int64 {
        x
    }
}

@Contract[
    inherits from InhNeg041Base
]
class InhNeg041Sub <: InhNeg041Base {
    public init() {
        super()
    }

    public override func f(x: Int64): Int64 {
        x + 1
    }

    // The clause names the parent's `r`, but this `f(String)` overload has no
    // inherited contract of its own, so the reference cannot resolve.
    @Contract[
        inherits requires InhNeg041Base.r
    ]
    public func f(x: String): String {
        x
    }
}

main() {
}
