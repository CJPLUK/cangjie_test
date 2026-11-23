/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-EXT-004: design expects a compile error for a class-level `variable`
// clause in an `extend` member contract. The implementation accepts it: the
// macro parses it as a function-level auxiliary variable, which is a legal
// function-contract clause. Landed as a compile-positive control (R-EXT-2).
// EXEC-PIPE-0: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

class ExtNegBase {
    public func f(): Int64 {
        1
    }
}

extend ExtNegBase {
    @Contract[
        variable v: Int64 = 0
    ]
    public func g(): Unit {}
}

main() {
}
