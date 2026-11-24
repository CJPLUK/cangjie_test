/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-057: an `inherits` clause cannot carry an invariant visibility
// selector or `static`; a `variable` clause cannot carry a visibility selector.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `inherits` cannot have an invariant visibility selector or `static`
// ASSERT: scan `variable` cannot have an invariant visibility selector
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
open class CovTypeBase02 {
    public init() {}
}

@Contract [
    on_public inherits from CovTypeBase02
]
class CovNegInheritsVis <: CovTypeBase02 {
    public init() {}
}

@Contract [
    static inherits from CovTypeBase02
]
class CovNegInheritsStatic <: CovTypeBase02 {
    public init() {}
}

@Contract [
    on_private variable v: Int64 = 0
]
class CovNegVarVisibility {
    public init() {}
}

main() {
}
