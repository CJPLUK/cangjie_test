/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-PROP-020: a local function carrying `@Contract` inside a property
// accessor keeps its contract; the property path used to skip
// `absorbLocalFunctionContracts`, so `requires false` never fired (audit
// report 2 #20). The accessor itself must carry a `@Contract` attribute for
// the absorption to run.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class PropAccessorLocal {
    @Contract [get ensures r: true]
    public prop p: Int64 {
        get() {
            @Contract [requires false]
            func g(): Int64 { 1 }
            return g()
        }
    }
}

main() {
    let c = PropAccessorLocal()
    var blocked = false
    try {
        let _ = c.p
    } catch (e: ContractCheckRequiresException) {
        blocked = true
    }
    if (!blocked) {
        throw Exception("local function contract inside accessor was silently dropped")
    }
    println("ok")
}
