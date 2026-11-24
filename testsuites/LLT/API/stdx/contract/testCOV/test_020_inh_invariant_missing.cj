/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-020: selecting an invariant name that the parent does
// not declare is reported instead of silently producing an empty inheritance.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan no inherited invariant matches the requested name
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable counter: Int64 = 0
    invariant [lower] counter >= 0
]
open class InvMissBase {
    public init() {}
}

@Contract [
    inherits invariant InvMissBase.missing
]
class InvMissChild <: InvMissBase {
    public init() {}
}

main(): Int64 {
    0
}
