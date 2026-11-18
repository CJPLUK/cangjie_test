/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INH-015 (implementation deviation): DT expects the renamed inheritance
// clause `y = Base.x` to make `y` usable in the child contract as an alias of
// `Base.x`. Design v2 §3.4.1 only keeps selective inheritance for invariants
// (`inherits invariant <type>.<name>` / `inherits invariant <new> = <type>.<name>`);
// selective variable inheritance and variable renaming were dropped, so
// `variable y = Base.count` is parsed as a variable declaration and rejected.
// The current diagnostic is pinned here; there is no runtime case for 015.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan variable clause needs a name and `:` before its type
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable count: Int64 = 5
    invariant [Inv] count > 0
]
open class InhNeg015Base {
    public init() {}
}

@Contract[
    variable y = InhNeg015Base.count
]
class InhNeg015Sub <: InhNeg015Base {
    public init() {
        super()
    }
}

main() {
}
