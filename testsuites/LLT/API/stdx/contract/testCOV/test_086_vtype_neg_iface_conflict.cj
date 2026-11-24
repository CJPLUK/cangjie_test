/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-086: an interface redeclaring a member without
// `inherits from` may not reuse a same-kind contract name declared by its
// parent. The conflict is reported while the interface body is being generated.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan override of `work(Int64)` both declare contract `pos`; rename one with `=`
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
interface VCovNegIfaceBase {
    @Contract [
        requires [pos] x > 0
    ]
    func work(x: Int64): Int64
}

@Contract
interface VCovNegIfaceChild <: VCovNegIfaceBase {
    @Contract [
        requires [pos] x > 0
    ]
    func work(x: Int64): Int64
}

main() {
}
