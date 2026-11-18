/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// CT-INH-051: inheriting a member contract from a generic parent with explicit
// type arguments. The substitution of type arguments used to rewrite the value
// expression `x` (the lowercase type parameter name that also names the
// method's value parameter) into the type `Int64`, so the expanded condition
// failed to parse (audit report 2 #21). The parent is a separate package, so
// the metadata comes from the on-disk `.cmeta` record; the inherited
// `requires [r] x > 0` must resolve `x` to the override's value parameter and
// fire at runtime.
// DEPENDENCE: inh_gen_lib.cj
// EXEC: rm -rf %n_meta && mkdir -p %n_meta
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhgenlib %compiler %import-cangjie-stdx %cmp_opt inh_gen_lib.cj --output-type=staticlib -o lib%n_inhgen.a
// EXEC: CANGJIE_STDX_CONTRACT_META_DIR=%n_meta CANGJIE_STDX_CONTRACT_PKG_NAME=inhgenconsumer %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt --import-path . -L . -l %n_inhgen
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*
import inhgenlib.*

@Contract [inherits from inhgenlib.GenBase<Int64>]
class InhGenChild <: GenBase<Int64> {
    public override func f(x: Int64): Int64 { x }
}

main() {
    let c = InhGenChild()
    if (c.f(1) != 1) {
        throw Exception("override body did not run")
    }
    var blocked = false
    try {
        let _ = c.f(-1)
    } catch (e: ContractCheckRequiresException) {
        blocked = true
    }
    if (!blocked) {
        throw Exception("inherited requires was not enforced on the generic-parent override")
    }
    println("ok")
}
