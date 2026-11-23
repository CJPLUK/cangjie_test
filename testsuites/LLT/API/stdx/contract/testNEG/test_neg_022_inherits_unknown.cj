/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-022: `inherits` must reference a known parent type.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan inheritance reference does not match a declared parent type
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    inherits from Unknown
]
class C {
}

main() {
}
