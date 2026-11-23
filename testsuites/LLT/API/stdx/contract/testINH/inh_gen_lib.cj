/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Parent library for CT-INH-051: a generic parent class whose member contract
// uses the lowercase type parameter name `x` that also names the method's
// value parameter. The child inherits through
// `inherits from inhgenlib.GenBase<Int64>`; the type-argument substitution
// used to rewrite the value expression `x` into the type `Int64` and the
// expanded clause failed to parse (audit report 2 #21).
package inhgenlib

import stdx.contract.macros.*

@Contract[]
public open class GenBase<x> {
    @Contract [requires [r] x > 0]
    public open func f(x: Int64): Int64 { x }
}
