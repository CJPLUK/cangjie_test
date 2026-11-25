/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-017: an inherited invariant and a locally declared `variable`
// that share a name but come from different origins are reported.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan an invariant and a `variable` clause from different origins both use the name `n`
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable v: Int64 = 0
    invariant [n] v >= 0
]
open class CrossBase {
    public init() {}
}

@Contract [
    inherits from CrossBase
    variable n: Int64 = 1
]
class CrossChild <: CrossBase {
    public init() {}
}

main(): Int64 {
    0
}
