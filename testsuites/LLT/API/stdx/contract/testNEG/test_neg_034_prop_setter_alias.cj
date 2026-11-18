/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-034: a directly annotated property contract's setter clauses use the
// canonical alias `value`; the macro must rewrite it to the setter's real
// parameter name so the generated accessor references a bound identifier
// (audit 16.19). Previously the generated code failed with
// `undeclared identifier 'value'`.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*
import stdx.contract.runtime.*

class Neg034PropSetterAlias {
    private var store: Int64 = 0

    @Contract[set requires value > 0]
    public mut prop p: Int64 {
        set(l) { store = l }
        get() { store }
    }
}

main() {
    let c = Neg034PropSetterAlias()
    c.p = 5
    if (c.p != 5) {
        throw Exception("setter did not store the assigned value")
    }
    var blocked = false
    try {
        c.p = -1
    } catch (e: ContractCheckRequiresException) {
        blocked = true
    }
    if (!blocked) {
        throw Exception("setter contract was not enforced for the aliased parameter")
    }
    println("ok")
}
