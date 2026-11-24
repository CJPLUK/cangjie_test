/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-043: extend blocks cannot declare type-level invariants or
// variables; an extend or interface cannot inherit contracts from a type
// that is not among its declared parents.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan extend type-level contracts cannot declare or inherit invariants
// ASSERT: scan extend type-level contracts cannot declare or inherit abstract variables
// ASSERT: scan does not match a declared parent type
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class CovNegExtHost {
    public init() {}
}

@Contract [ invariant true ]
extend CovNegExtHost {
    public func e1(): Int64 { 1 }
}

@Contract [ variable v: Int64 = 0 ]
extend CovNegExtHost {
    public func e2(): Int64 { 2 }
}

@Contract [ inherits from CovNegUnrelatedIface ]
extend CovNegExtHost {
    public func e3(): Int64 { 3 }
}

@Contract [ inherits from CovNegUnrelatedIface2 ]
interface CovNegIfaceBadParent {
    func e4(): Int64
}

main() {
}
