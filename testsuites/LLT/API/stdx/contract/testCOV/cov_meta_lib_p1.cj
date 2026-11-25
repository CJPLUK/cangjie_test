/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV metadata library p1: defines `Amb` with a named invariant.
package covmeta1

import stdx.contract.macros.*

@Contract [ invariant [nonneg] true ]
public open class Amb {
    public init() {}

    @Contract [ requires x > 0 ]
    public open func touch(x: Int64): Int64 {
        x
    }
}
