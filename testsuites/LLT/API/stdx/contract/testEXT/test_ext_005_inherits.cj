/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-EXT-005: `inherits` is not a valid clause inside an `extend` member
// contract; the parser only accepts function-contract clauses there.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan `inherits` needs `requires`, `ensures`, `throws`, or `variable`, got from
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class ExtNegBase {
    public func f(): Int64 {
        1
    }
}

extend ExtNegBase {
    @Contract[
        inherits from ExtNegBase
    ]
    public func g(): Unit {}
}

main() {
}
