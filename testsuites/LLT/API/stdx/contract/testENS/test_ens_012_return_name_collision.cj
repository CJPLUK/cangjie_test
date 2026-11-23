/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-ENS-012: the `ensures` return identifier must not collide with a parameter name
// visible in the function scope. 
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan collides with parameter name
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract[
    ensures param: param > 0
]
func collidesWithParameter(param: Int64): Int64 {
    0
}
