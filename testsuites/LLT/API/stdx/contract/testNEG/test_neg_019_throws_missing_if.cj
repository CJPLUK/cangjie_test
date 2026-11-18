/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-019: a `throws` clause needs an `if` condition after the exception
// type.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan throws clause needs
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class BizEx <: Exception {
    public init() {
        super("biz")
    }
}

@Contract[
    throws BizEx
]
func f(): Unit {
}

main() {
}
