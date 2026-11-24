/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-047: `inherits` without `from`, `inherits from` with an
// unsupported modifier, and a `[conforming]` block missing `]` are all rejected
// by the clause parser.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan needs `from` or `invariant`
// ASSERT: scan supports only the `[conforming]` modifier
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

interface CovInhParent {
    func f(x: Int64): Int64
}

@Contract [
    inherits CovInhParent
]
class CovInhMissingFrom <: CovInhParent {
    public init() {}

    public func f(x: Int64): Int64 {
        x
    }
}

@Contract [
    inherits from CovInhParent [bogus]
]
class CovInhBadModifier <: CovInhParent {
    public init() {}

    public func f(x: Int64): Int64 {
        x
    }
}

@Contract [
    inherits from CovInhParent [conforming extra]
]
class CovInhUnclosedModifier <: CovInhParent {
    public init() {}

    public func f(x: Int64): Int64 {
        x
    }
}
