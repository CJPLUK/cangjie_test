/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-002: `@Contract` on an `enum` is rejected with a compile error:
// enums cannot declare contracts (design v2 §3.1).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan has no effect on enum declarations
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
enum E {
    A | B
}

main() {
}
