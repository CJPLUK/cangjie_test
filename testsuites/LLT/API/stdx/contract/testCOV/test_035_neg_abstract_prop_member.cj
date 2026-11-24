/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-035: an abstract property declared inside a type-level
// contract has no accessor bodies, so the type contract asks for the contract to be
// declared on the enclosing type instead of on the abstract property.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan has no accessor to host its contract checks
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    invariant true
]
abstract class CovAbsPropMemberClass {
    public init() {}

    @Contract [
        get {
            ensures r: r >= 0
        }
    ]
    prop absProp: Int64
}
