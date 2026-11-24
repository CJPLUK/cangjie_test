/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Helper library for COV-META-CORRUPT: records with rich clauses, property
// attributes, origin arguments of several type-node kinds and a generic
// inheritance chain. Compiled with CANGJIE_STDX_CONTRACT_PKG_NAME=covmeta.
package covmeta

import stdx.contract.macros.*

@Contract []
public interface CovCorruptMagic {
    @Contract [
        requires [mp] x > 0
        ensures [mq] r: r >= 0
    ]
    func apply(x: Int64): Int64
}

@Contract [
    invariant [ci] 1 > 0
]
public interface CovCorruptClause {
    @Contract [
        requires [cp] x >= 0
        ensures [cq] r: r >= x
    ]
    func apply(x: Int64): Int64
}

@Contract [
    variable audit: Int64 = 0
    invariant [mi] total >= 0
]
public open class CovCorruptMember {
    public var total: Int64 = 0

    public init() {}

    @Contract [
        ensures [ma] r: r >= 0
    ]
    public open func noArg(): Int64 {
        1
    }

    @Contract [
        requires [mb] d >= 0
        ensures [mc] total >= d
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}

@Contract [
    variable pscale: Int64 = 1
]
public interface CovCorruptProperty {
    @Contract [
        get {
            requires [pp] pscale > 0
            ensures [pq] r: r >= 0
        }
        set {
            requires [ps] value >= 0
            ensures [pt] value >= 0
        }
    ]
    mut prop item: Int64
}

@Contract [
    invariant [xi] 1 > 0
]
public interface CovCorruptParse {
    @Contract [
        requires [xp] x != 0
        ensures [xq] r: r != 0
    ]
    func apply(x: Int64): Int64
}

@Contract [
    invariant [si] 1 > 0
]
public interface CovCorruptStale {
    @Contract [
        requires [sp] x >= 100
        ensures [sq] r: r >= 0
    ]
    func apply(x: Int64): Int64
}

@Contract [
    invariant [ni] 1 > 0
]
public interface CovCorruptNoFp {
    @Contract [
        requires [np] x < 1000
    ]
    func apply(x: Int64): Int64
}

@Contract [
    invariant [ti] 1 > 0
]
public interface CovCorruptTrunc {
    @Contract [
        requires [tp] x > -1000
    ]
    func apply(x: Int64): Int64
}

@Contract []
public interface CovCorruptWrong {
    @Contract [
        requires [wp] x > 0
    ]
    func apply(x: Int64): Int64
}

// Generic chain: `CovCorruptMid` inherits clauses whose origin arguments are a
// tuple type; `CovCorruptPrim` uses a primitive type; `CovCorruptFunc` a
// function type; `CovCorruptOpt` an option type.
@Contract [
    invariant [bi] 1 > 0
]
public interface CovCorruptBase<T> {
    @Contract [
        requires [bp] 1 > 0
    ]
    func apply(x: T): T
}

@Contract [
    inherits from CovCorruptBase<(S, S)>
]
public interface CovCorruptMid<S> <: CovCorruptBase<(S, S)> {
    func pick(x: (S, S)): (S, S)
}

@Contract [
    inherits from CovCorruptBase<Int64>
]
public interface CovCorruptPrim <: CovCorruptBase<Int64> {
}

@Contract [
    inherits from CovCorruptBase<(Int64) -> Int64>
]
public interface CovCorruptFunc <: CovCorruptBase<(Int64) -> Int64> {
}

@Contract [
    inherits from CovCorruptBase<?Int64>
]
public interface CovCorruptOpt <: CovCorruptBase<?Int64> {
}

// Leaf carrying a valid record that also contains inherited member attributes
// with origins and a property contract reached through a parent.
@Contract [
    inherits from CovCorruptProperty
]
public interface CovCorruptLeaf <: CovCorruptProperty {
}
