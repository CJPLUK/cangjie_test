/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-036: an auxiliary-variable update inside an expression is a value
// position, not a standalone statement: both the postfix (`x++`) and prefix
// (`++x`) forms are rejected, including when the update continues an
// expression written across a newline (`1 +\n x++`).
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan writes a slot and only works as a standalone statement
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

@Contract [variable count: Int64 = 0]
func covAuxPostfixValue(): Int64 {
    @ghost (
        count = count + count++
    )
    return count
}

@Contract [variable count: Int64 = 0]
func covAuxPrefixValue(): Int64 {
    @ghost (
        count = count + ++count
    )
    return count
}

@Contract [variable count: Int64 = 0]
func covAuxPrefixDecrementValue(): Int64 {
    @ghost (
        count = count + --count
    )
    return count
}

@Contract [variable count: Int64 = 0]
func covAuxContinuedValue(): Int64 {
    @ghost (
        count = 1 +
        count++
    )
    return count
}

main() {
}
