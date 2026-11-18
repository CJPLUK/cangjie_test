/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-INV-025: `on_public` invariants apply to interface default members,
// which are implicitly public. The visibility classifier used to treat them
// as internal, so the tagged invariant never ran on default member access
// (audit report 2 #31). The implementation class must use the `inherits from`
// clause so the interface invariant is attached.
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

var invTrace25 = ""

func invTick25(s: String): Bool {
    invTrace25 += s
    return true
}

@Contract [on_public invariant [V25] invTick25("v")]
interface InvOnPublicDefaultI {
    func describe(): Int64 { 1 }
}

@Contract [inherits from InvOnPublicDefaultI]
class InvOnPublicDefaultC <: InvOnPublicDefaultI {}

main() {
    let c = InvOnPublicDefaultC()
    let r = c.describe()
    if (r != 1) {
        throw Exception("default member body did not run")
    }
    // The constructor and the default member access each record one tick.
    if (invTrace25 != "vv") {
        throw Exception("on_public invariant did not run on the interface default member, trace=" + invTrace25)
    }
    println("ok")
}
