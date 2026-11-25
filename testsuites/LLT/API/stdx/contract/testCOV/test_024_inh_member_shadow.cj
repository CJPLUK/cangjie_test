/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-024: a selectively inherited contract variable is shadowed by the
// inheriting method's parameter (same name), and a user condition that starts
// with `this` without a following member access is not treated as a generated
// checker call.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited contract variable `y` is shadowed by the inheriting member's parameter of the same name
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract []
open class CovInhShadowBase {
    public init() {}

    @Contract [
        variable y: Int64 = 1
        requires [r] x > y
    ]
    public open func run(x: Int64): Int64 {
        x
    }
}

@Contract []
class CovInhShadowChild <: CovInhShadowBase {
    public init() {}

    @Contract [
        inherits requires r = CovInhShadowBase.r
    ]
    public override func run(y: Int64): Int64 {
        y
    }
}

@Contract []
class CovInhThisCond {
    public init() {}

    @Contract [
        requires this > 0
    ]
    public func probe(x: Int64): Int64 {
        x
    }
}

main(): Int64 {
    0
}
