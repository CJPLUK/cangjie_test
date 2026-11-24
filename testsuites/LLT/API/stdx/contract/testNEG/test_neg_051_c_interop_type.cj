/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-051: `@Contract` on an `@C` interop struct is rejected with a dedicated
// compile error: interop types cannot declare contracts (design v2 §3.1.7).
// `@Contract` must be written before `@C`: the compiler moves annotations that precede
// an attribute macro out of the macro input, so only this order lets the macro see `@C`.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan is not supported on `@C` interop types
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract
@C
struct S {
    var x: Int64 = 0
}

main() {
}
