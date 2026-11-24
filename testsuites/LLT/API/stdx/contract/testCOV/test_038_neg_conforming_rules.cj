/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-038: negative coverage for `[conforming]` invariant checks,
// invariant inheritance name resolution, abstract variable declaration checks
// and reserved generated member names.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `[conforming]` invariant may only reference newly added abstract variables and member variables: `base`
// ASSERT: scan no inherited invariant matches the requested name
// ASSERT: scan abstract variable `selfRef` cannot use the enclosing type `NegConfE`
// ASSERT: scan abstract variable initializer may only reference earlier abstract variables with initial values: `later`
// ASSERT: scan abstract variable initializer may not read ordinary members or call member functions: `holder`
// ASSERT: scan function name `_contract_body` is reserved for generated contract helpers
// ASSERT: scan member name `_abs_kind` is reserved for generated contract storage
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [
    variable base: Int64 = 4
]
open class NegConfA {
    public init() {}
}

@Contract [
    inherits from NegConfA [conforming]
    invariant base > 0
]
class NegConfAChild <: NegConfA {
    public init() {
        super()
    }
}

@Contract [
    invariant [known] true
]
open class NegConfB {
    public init() {}
}

@Contract [
    inherits invariant NegConfB.missing
]
class NegConfBMissing <: NegConfB {
    public init() {
        super()
    }
}

@Contract [
    invariant [dup] true
    invariant [dup] true
]
open class NegConfC {
    public init() {}
}

@Contract [
    inherits invariant NegConfC.dup
]
class NegConfCDup <: NegConfC {
    public init() {
        super()
    }
}

@Contract [
    variable selfRef: NegConfE
]
class NegConfE {
    public init() {}
}

@Contract [
    variable first: Int64 = later + 1
    variable later: Int64 = 1
]
class NegConfF {
    public init() {}
}

@Contract [
    variable amt: Int64 = holder
]
class NegConfG {
    public var holder: Int64 = 1

    public init() {}
}

@Contract [
    variable kind: Int64 = 0
]
class NegConfH {
    public init() {}

    public func _contract_body(): Unit {}

    public var _abs_kind: Int64 = 0
}

main() {
}
