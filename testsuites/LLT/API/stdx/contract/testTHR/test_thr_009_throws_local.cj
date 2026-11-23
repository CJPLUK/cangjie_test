/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-THR-009 (negative half): a `throws` condition may not reference a
// variable declared inside the function body.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan undeclared identifier
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class ThrExA <: Exception {
    public init(m!: String = "ThrExA") {
        super(m)
    }
}

@Contract[
    throws ThrExA if (localValue > 0)
]
func thrLocalCond(x: Int64): Unit {
    let localValue = x
}

main() {
}
