/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-034: a contract attached directly to an abstract interface
// property has no accessor bodies to wrap, so the macro asks for the contract to
// be declared on the enclosing type instead.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan requires accessor bodies
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

interface CovAbsPropIface {
    @Contract [
        get {
            ensures r: r >= 0
        }
    ]
    prop absProp: Int64
}
