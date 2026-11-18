/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-026: the self-type restriction on auxiliary variables (design L544)
// applies to structs and interfaces as well: the variable type may not be the
// enclosing type itself, while an `Option`-wrapped reference stays legal
// (covered by CT-CLS-014 for classes).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan cannot use the enclosing type
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    variable s: S
]
struct S {
    public init() {}
}

@Contract[
    variable i: I
]
interface I {
}

main() {
}
