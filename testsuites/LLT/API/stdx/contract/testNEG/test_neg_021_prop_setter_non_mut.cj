/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-021: property `set` contracts are only allowed on `mut prop`.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan immutable property cannot have setter
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
class C {
    public prop p: Int64 {
        get() {
            1
        }
        set(v) {
        }
    }
}

main() {
}
