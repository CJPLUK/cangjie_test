/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-NEG-039: interface-level `variable`s are storage-backed, so an interface default
// member may read them directly. The default member used to draw the spurious
// "`flag` may only be accessed in `@ghost`..." warning (audit 16.27).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args

import stdx.contract.macros.*

@Contract[
    variable flag: Bool = false
    invariant flag
]
interface Neg039InterfaceDefaultRead {
    func describe(): String {
        if (flag) {
            return "on"
        }
        return "off"
    }
}

class Neg039Impl <: Neg039InterfaceDefaultRead {
    private var raw: Bool = false
    public mut prop flag: Bool {
        get() { raw }
        set(v) { raw = v }
    }
    public func describe(): String {
        if (raw) { "on" } else { "off" }
    }
}

main() {
    let impl = Neg039Impl()
    if (impl.describe() != "off") {
        throw Exception("describe() returned an unexpected value")
    }
    println("ok")
}
