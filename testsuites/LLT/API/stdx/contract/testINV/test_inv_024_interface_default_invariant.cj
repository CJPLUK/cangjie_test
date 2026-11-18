/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INV-024: the type invariant of an interface is checked by the default
// property accessor. The default getter used to bypass the invariant entirely
// and returned -1 silently (audit report 2 #19); the same interface's default
// method always threw. The implementation class must use the
// `inherits from` clause so the invariant checker is attached.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

@Contract [invariant this.p > 0]
interface InvDefaultAccessorI {
    prop p: Int64 { get() { -1 } }
}

@Contract [inherits from InvDefaultAccessorI]
class InvDefaultAccessorC <: InvDefaultAccessorI {}

main() {
    let c = InvDefaultAccessorC()
    var blocked = false
    try {
        let _ = c.p
    } catch (e: ContractCheckInvariantException) {
        blocked = true
    }
    if (!blocked) {
        throw Exception("interface invariant was not checked by the default accessor")
    }
    println("ok")
}
