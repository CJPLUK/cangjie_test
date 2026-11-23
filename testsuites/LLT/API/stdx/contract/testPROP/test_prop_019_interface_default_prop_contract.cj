/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-PROP-019: a member contract on an interface default property is enforced
// when the interface carries a type-level `@Contract`. The interface property
// branch used to only record the attribute without rebuilding the accessor, so
// the default getter returned -1 silently (audit report 2 #18; the same shape
// without the type-level `@Contract []` always threw).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract[]
interface PropDefaultContractI {
    @Contract [get ensures r: r > 0]
    prop p: Int64 { get() { -1 } }
}

class PropDefaultContractC <: PropDefaultContractI {}

main() {
    let c = PropDefaultContractC()
    var blocked = false
    try {
        let _ = c.p
    } catch (e: ContractCheckEnsuresException) {
        blocked = true
    }
    if (!blocked) {
        throw Exception("interface default property contract was silently dropped")
    }
    println("ok")
}
