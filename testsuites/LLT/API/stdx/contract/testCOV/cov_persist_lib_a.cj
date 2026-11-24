/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Parent library for COV-PERSIST-03. Compiled with
// CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa so the records are package qualified.
package inhmetaa

import stdx.contract.macros.*

@Contract [
    variable audit: Int64 = 0
]
public open class CovPrefDup {
    public var total: Int64 = 0

    public init() {}

    @Contract [
        requires d >= 0
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}

@Contract [
    variable audit: Int64 = 0
]
public open class CovPrefOther {
    public var total: Int64 = 0

    public init() {}

    @Contract [
        requires d >= 0
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}
