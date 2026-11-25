/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Second parent library for COV-PERSIST-03. It declares the same simple type
// name `CovPrefOther` as inhmetaa but with a different `requires` condition, so
// the two on-disk records differ and the consumer must prefer the record of
// its own package.
package inhmetab

import stdx.contract.macros.*

@Contract [
    variable audit: Int64 = 0
]
public open class CovPrefOther {
    public var total: Int64 = 0

    public init() {}

    @Contract [
        requires d >= 1
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}
