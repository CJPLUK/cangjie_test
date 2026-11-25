/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-052: a member property contract that inherits a parent
// property contract needs an enclosing type-level contract to host the inheritance.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inherited property contracts require an enclosing type contract
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

interface CovPropInhBase {
    prop p: Int64 {
        get() {
            1
        }
    }
}

class CovPropNoTypeContract {
    public init() {}

    @Contract [
        get {
            inherits requires CovPropInhBase.p
        }
    ]
    public prop q: Int64 {
        get() {
            1
        }
    }
}
