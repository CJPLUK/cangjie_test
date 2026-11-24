/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-019: two unrelated parents declaring the same invariant
// name are reported; the diamond case (same ancestor twice) must stay silent.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited invariant `dup` is declared by multiple ancestors
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable va: Int64 = 0
    invariant [dup] va >= 0
]
interface DupBaseA {}

@Contract [
    variable vb: Int64 = 0
    invariant [dup] vb >= 0
]
interface DupBaseB {}

@Contract [
    inherits from DupBaseA
    inherits from DupBaseB
]
class DupChild <: DupBaseA & DupBaseB {
    public init() {}
}

main(): Int64 {
    0
}
