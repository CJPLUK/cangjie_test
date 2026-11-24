/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-039: a `const func` cannot host function contracts.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan function contract requires an ordinary, non-const function
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [ invariant true ]
class CovNegConstHost {
    public init() {}

    @Contract [ requires x > 0 ]
    const func cf(x: Int64): Int64 {
        x
    }
}

main() {
}
