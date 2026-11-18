/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-014: a class-level auxiliary variable may not use the enclosing class
// as its type without `Option` wrapping.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot use the enclosing type
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable c: C
]
class C {
}

main() {
}
