/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-016: under `inherits from ... [conforming]`, a newly written
// invariant may only reference newly added abstract variables and member
// variables; referencing a purely inherited auxiliary variable is reported.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan a `[conforming]` invariant may only reference newly added abstract variables and member variables: `baseVal`
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable baseVal: Int64 = 0
    invariant [baseInv] baseVal >= 0
]
open class ConfBase {
    public init() {}
}

@Contract [
    inherits from ConfBase [conforming]
    invariant [myInv] baseVal >= 0
]
class ConfChild <: ConfBase {
    public init() {}
}

main(): Int64 {
    0
}
