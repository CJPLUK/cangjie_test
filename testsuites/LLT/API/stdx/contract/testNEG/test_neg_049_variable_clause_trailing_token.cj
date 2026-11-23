/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-049: tokens sharing the `variable` clause's token slice were parsed
// as part of the clause and silently dropped, so a trailing `requires` never
// took effect (audit report 2 #17). The clause tail must be rejected.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan unexpected token after contract clause
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract [variable v: Int64 requires 1 > 2]
func negVariableTailToken(): Int64 { 0 }

main() {
    println("unreachable")
}
