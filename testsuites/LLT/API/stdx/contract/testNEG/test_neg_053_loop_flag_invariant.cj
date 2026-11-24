/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-053: invariant expressions are evaluated at the generated check point, which
// sits inside the scope of the injected `_contract_do_while_first_iteration` flag. A
// user invariant that names that reserved identifier is rejected instead of reading
// the flag.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan is reserved for generated code
// ASSERT: scan-not core dumped
import stdx.contract.macros.*

func negLoopFlagInvariant(): Int64 {
    var i = 0
    var _contract_do_while_first_iteration = true
    @loopInvariant[_contract_do_while_first_iteration](do {
        i += 1
    } while (i < 1))
    i
}

main() {
    println("unreachable")
}
