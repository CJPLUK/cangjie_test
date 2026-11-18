/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-044: a named parent invariant inherited into the child and a child
// `variable` clause must not share a name (audit report 2, defect 47; fixed in
// audit report 3, omission 4 via `validateCrossOriginNames`): both generate
// same-named members, which used to surface only as a generic compiler
// `redefinition` (or pass silently).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan different origins both use the name
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    invariant [I1] true
]
open class CrossParent {}

@Contract [
    inherits from CrossParent
    variable I1: Int64 = 1
]
class CrossChild <: CrossParent {}

main() {
    println("unreachable")
}
