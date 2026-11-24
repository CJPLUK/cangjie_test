/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-045: compile-time diagnostics of the inheritance resolver, the
// extend/interface generators and the function/property contract validators.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan wrong number of type arguments for `CovNegGen`
// ASSERT: scan inheritance reference does not match a declared parent type
// ASSERT: scan parent contract metadata is unavailable for `CovNegPlain`
// ASSERT: scan must be declared `open` to inherit invariants
// ASSERT: scan no inherited invariant matches the requested name
// ASSERT: scan extend type-level contracts cannot declare or inherit abstract variables
// ASSERT: scan extend type-level contracts cannot declare or inherit invariants
// ASSERT: scan `set` clauses are only allowed on `mut prop`
// ASSERT: scan collides with callable name
// ASSERT: scan duplicate contract name `d1` on the same callable
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

// --- wrong number of type arguments on an inherited generic parent ----------
@Contract [
    invariant [sizeInv] n >= 0
]
open class CovNegGen<T> {
    public var n: T
    public init(v!: T) {
        n = v
    }
}

@Contract [
    inherits from CovNegGen<Int64, Int64>
]
class CovNegGenBad <: CovNegGen<Int64> {
    public init() {
        super(v: 0)
    }
}

// --- inheritance reference that is not a declared parent --------------------
@Contract [
    inherits from String
]
class CovNegNotParent {
    public init() {}
}

// --- parent that carries no contract metadata ------------------------------
open class CovNegPlain {
    public init() {}
}

@Contract [
    inherits from CovNegPlain
]
class CovNegNoMeta <: CovNegPlain {
    public init() {
        super()
    }
}

// --- non-open parent class with invariants ---------------------------------
@Contract [
    invariant [nmInv] n >= 0
]
class CovNegClosed {
    public var n: Int64 = 0
    public init() {}
}

@Contract [
    inherits from CovNegClosed
]
class CovNegClosedChild <: CovNegClosed {
    public init() {
        super()
    }
}

// --- no invariant matches the requested name -------------------------------
@Contract [
    invariant [realInv] n >= 0
]
open class CovNegInv {
    public var n: Int64 = 0
    public init() {}
}

@Contract [
    inherits from CovNegInv
    inherits invariant missing = CovNegInv.realInv
    inherits invariant CovNegInv.absentInv
]
class CovNegInvChild <: CovNegInv {
    public init() {
        super()
    }
}

// --- extend type-level contracts -------------------------------------------
@Contract [
    variable extVar: Int64
    invariant [extInv] this > 0
]
extend Int64 {
    public func covExt(): Int64 {
        this
    }
}

// --- `set` clauses on a read-only property ---------------------------------
class CovNegReadOnlyProp {
    @Contract [
        set {
            requires value > 0
        }
    ]
    prop covReadOnly: Int64 {
        get() {
            0
        }
    }

    public init() {}
}

// --- ensures return name collides with the callable name -------------------
@Contract [
    ensures covDup: r > 0
]
func covDup(): Int64 {
    1
}

// --- duplicate contract label on the same callable -------------------------
@Contract [
    requires [d1] a > 0
    requires [d1] a > 1
]
func covDupLabel(a: Int64): Int64 {
    a
}

main() {
    0
}
