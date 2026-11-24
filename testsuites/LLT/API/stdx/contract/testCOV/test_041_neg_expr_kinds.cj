/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-041: malformed condition and target shapes: a bare `$pre`, a
// `throws` without a type, a `$pre` call missing its closing paren, an
// `inherits from` naming a non-type, and a named invariant that is declared
// by multiple ancestors.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `$pre` must be used as the snapshot call
// ASSERT: scan contract type failed to parse
// ASSERT: scan expected `)` after `$pre` argument
// ASSERT: scan declared by multiple ancestors
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [ ensures $pre > 0 ]
func covNegBarePre(): Int64 {
    1
}

@Contract [ throws if x < 0 ]
func covNegThrowsNoType(x: Int64): Int64 {
    x
}

@Contract [ ensures r: $pre(r > 0 ]
func covNegPreNoParen(): Int64 {
    1
}

@Contract [ inherits from 1 ]
class CovNegNumericParent {
    public init() {}
}

@Contract [ invariant [shared] true ]
interface CovNegAmbB {
    func b(): Int64
}

@Contract [
    inherits from CovNegAmbB
    invariant [shared] true
]
interface CovNegAmbA <: CovNegAmbB {
    func a(): Int64
}

@Contract [ inherits invariant CovNegAmbA.shared ]
class CovNegAmbiguous <: CovNegAmbA {
    public init() {}
    public func a(): Int64 {
        1
    }
    public func b(): Int64 {
        1
    }
}

main() {
}
