/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// Parent library for the cross-package inheritance persistence cases
// (test_inh_047/048/049/050). It is compiled by the consuming test with
// CANGJIE_STDX_CONTRACT_PKG_NAME=inhmetaa and a shared CANGJIE_STDX_CONTRACT_META_DIR, so the `@Contract`
// macro publishes a package-qualified `inhmetaa.PersistBase.cmeta` record that
// a separately compiled consumer package loads from disk.
package inhmetaa

import stdx.contract.macros.*

@Contract[
    variable audit: Int64 = 0
]
public open class PersistBase {
    public var total: Int64 = 0

    public init() {}

    @Contract[
        requires d >= 0
    ]
    public open func add(d: Int64): Unit {
        total += d
    }
}
