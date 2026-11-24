/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-037: a direct contract on a bodiless interface method is
// rejected, and an inherited function contract on a top-level function (which has
// no enclosing type contract) is rejected as well.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot annotate a function without a body
// ASSERT: scan inherited function contracts require an enclosing type contract
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

interface CovAbsIface {
    @Contract [
        requires true
    ]
    func absF(x: Int64): Int64
}

interface CovInhIface {
    func f(x: Int64): Int64
}

@Contract [
    inherits requires CovInhIface.f
]
func covInheritWithoutOwner(x: Int64): Int64 {
    x
}
