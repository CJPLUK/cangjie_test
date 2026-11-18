/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Second parent library for test_inh_049 (ambiguous metadata). It declares the
// same simple type name as inh_persist_lib_a.cj in a different package, so two
// records `inhmetaa.PersistBase.cmeta` and `inhmetab.PersistBase.cmeta` coexist
// in one meta directory and a simple-name reference cannot pick between them.
package inhmetab

import stdx.contract.macros.*

@Contract[
    variable audit: Int64 = 0
]
public open class PersistBase {
    public var total: Int64 = 0

    public init() {}

    @Contract[
        requires d > 0
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}
