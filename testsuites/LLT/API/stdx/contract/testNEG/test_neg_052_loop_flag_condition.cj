/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-052: the do-while invariant expansion injects a local named
// `_contract_do_while_first_iteration`. The macro cannot see enclosing scopes, so a
// user reference to that reserved name inside the loop would be silently rebound to
// the generated flag; the expansion rejects it instead.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan is reserved for generated code
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

func negLoopFlagCondition(): Int64 {
    var i = 0
    var _contract_do_while_first_iteration = true
    @loopInvariant[true](do {
        i += 1
    } while (i < 2 && _contract_do_while_first_iteration))
    i
}

main() {
    println("unreachable")
}
