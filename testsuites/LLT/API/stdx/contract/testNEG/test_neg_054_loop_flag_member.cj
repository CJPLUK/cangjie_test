/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-054: `_contract_do_while_first_iteration` is generator-owned. A member with
// that name would be shadowed by the flag inside an annotated do-while, so the
// generated member-name check rejects the declaration.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan is reserved for generated contract helpers
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

@Contract []
class NegLoopFlagMember {
    var _contract_do_while_first_iteration: Bool = true
}

main() {
    println("unreachable")
}
