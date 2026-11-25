/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV persist library built without CANGJIE_STDX_CONTRACT_PKG_NAME: the
// persisted record carries an empty package name, which the loader must
// still attribute to the bare type name.
package nopkg

import stdx.contract.macros.*

@Contract [
    variable total: Int64 = 0
    invariant [nonneg] total >= 0
]
public open class NopkgBase {
    public init() {}

    @Contract [ requires d >= 0 ]
    public func add(d: Int64): Unit {
        @ghost ( total += d )
    }
}
