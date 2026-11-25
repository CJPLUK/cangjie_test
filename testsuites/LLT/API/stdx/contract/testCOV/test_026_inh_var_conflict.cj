/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-026: same-name inherited auxiliary variables whose
// declarations differ (type) must be reported instead of silently merging.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited abstract variable `clash` has conflicting declarations
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable clash: Int64 = 0
]
interface VarConfA {}

@Contract [
    variable clash: String = ""
]
interface VarConfB {}

@Contract [
    inherits from VarConfA
    inherits from VarConfB
]
class VarConfChild <: VarConfA & VarConfB {
    public init() {}
}

main(): Int64 {
    0
}
