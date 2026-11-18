/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-029: contracts on the primary constructor. The contract parser used
// to reject the primary constructor declaration (parse/declaration.cj did not
// pass astKind `PrimaryCtorDecl`), so the documented primary-constructor
// contracts never took effect (audit report 2 #4).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract[]
class ClsPrimaryCtor {
    @Contract [requires x > 0]
    ClsPrimaryCtor(public let x: Int64) {}
}

main() {
    let ok = ClsPrimaryCtor(5)
    if (ok.x != 5) {
        throw Exception("primary constructor body did not run")
    }
    var blocked = false
    try {
        let _ = ClsPrimaryCtor(-1)
    } catch (e: ContractCheckRequiresException) {
        blocked = true
    }
    if (!blocked) {
        throw Exception("primary constructor requires was not enforced")
    }
    println("ok")
}
