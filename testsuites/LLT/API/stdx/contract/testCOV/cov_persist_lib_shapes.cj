/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV persist library: a parent whose persisted metadata carries a property
// contract, a parenthesized `throws` type form, `inherits from` and
// `inherits invariant` clauses, and a class-level `variable`.
package covshapes

import stdx.contract.macros.*

public class ShapeErr <: Exception {
    public init() {
        super()
    }
}

@Contract [
    variable cnt: Int64 = 0
    invariant [found] cnt >= 0
]
public interface ShapeInvI<T> {
    func bump(x: T): Unit
}

@Contract [
    inherits from ShapeInvI<Int64>
    inherits invariant ShapeInvI<Int64>.found
]
public open class ShapeBase <: ShapeInvI<Int64> {
    public init() {}

    public func bump(x: Int64): Unit {
        ()
    }

    @Contract [ get { ensures r: r > 0 } ]
    public prop gauge: Int64 {
        get() {
            1
        }
    }

    @Contract [ throws (ShapeErr) if x < 0 ]
    public open func risky(x: Int64): Int64 {
        if (x < 0) {
            throw ShapeErr()
        }
        x
    }
}
