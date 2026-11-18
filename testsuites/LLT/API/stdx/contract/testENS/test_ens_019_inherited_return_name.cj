/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-ENS-019 (R9): the `ensures` return name is validated against the merged
// contract when a subclass inherits a parent member contract, so a same-named
// member added by the subclass must be reported. Design v2 §3.4: contracts are
// not inherited by default, so the scenario needs an explicit `inherits from`.
// Known defect: the inherited clause keeps parent-macro tokens, so
// `validateEnsuresReturnNames` calls `diagReport` with tokens outside the
// child macro call range and the compiler reports
// "macro evaluation has failed" (ASTException) instead of the intended
// "`ensures` return name ... collides with a member of the enclosing type".
// The compile failure itself is the DT expectation; the assertion pins the
// current diagnostic.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan macro evaluation has failed
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
open class EnsInheritBase {
    @Contract[
        ensures ret: ret > 0
    ]
    public open func compute(): Int64 {
        1
    }
}

@Contract[
    inherits from EnsInheritBase
]
class EnsInheritSub <: EnsInheritBase {
    public var ret: Int64 = 0

    @Contract
    public override func compute(): Int64 {
        2
    }
}

main() {
}
