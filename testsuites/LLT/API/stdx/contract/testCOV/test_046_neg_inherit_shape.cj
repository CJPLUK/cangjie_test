/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-046: malformed inheritance references: a tuple type and a
// function type where a parent is required, a wrong type-argument count, and
// an inherited contract `variable` shadowed by the overriding member's
// parameter.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan must name a parent class or interface
// ASSERT: scan wrong number of type arguments
// ASSERT: scan shadowed by the inheriting member's parameter
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [ inherits from (Int64, Int64) ]
class CovNegTupleParent {
    public init() {}
}

@Contract [ inherits from () -> Unit ]
class CovNegFuncParent {
    public init() {}
}

@Contract []
open class CovNegGenBase<T> {
    public init() {}
    @Contract [ variable acc: Int64 = 0 ]
    public func f(x: Int64): Int64 {
        x
    }
}

@Contract [ inherits from CovNegGenBase ]
class CovNegWrongArity <: CovNegGenBase<Int64> {
    public init() {}
}

@Contract []
open class CovNegShadowBase {
    public init() {}

    @Contract [
        variable guard: Int64 = 1
        requires guard > 0
    ]
    public func g(x: Int64): Int64 {
        x
    }
}

@Contract [ inherits from CovNegShadowBase ]
class CovNegShadowChild <: CovNegShadowBase {
    public init() {}

    public override func g(guard: Int64): Int64 {
        guard
    }
}

main() {
}
