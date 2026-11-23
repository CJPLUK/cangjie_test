/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-003: `invariant` clauses cannot be declared on `enum` members; the
// declaration is rejected by the parser.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan expected declaration
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
enum E2 {
    invariant true
    A | B
}

main() {
}
