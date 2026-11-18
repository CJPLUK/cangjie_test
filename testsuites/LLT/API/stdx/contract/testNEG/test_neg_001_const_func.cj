/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-001: contracts are not supported on `const` functions.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan function contract requires an ordinary, non-const function
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    requires true
]
const func constFunc(): Int64 {
    1
}

main() {
}
