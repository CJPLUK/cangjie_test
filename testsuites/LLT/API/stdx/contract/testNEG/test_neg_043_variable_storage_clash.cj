/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-043: `variable x` and `variable _abs_x` collide through the generated
// storage name (`_abs_x`); the macro must report a dedicated diagnostic instead
// of letting the compiler emit a generic `redefinition` (audit report 3,
// omission 3).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan abstract variable name `x` collides with the storage of another `variable` clause
// ASSERT: scan abstract variable name `_abs_x` collides with the storage of another `variable` clause
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [
    variable x: Int64 = 1
    variable _abs_x: Int64 = 2
]
class StorageClash {}

main() {
    println("unreachable")
}
