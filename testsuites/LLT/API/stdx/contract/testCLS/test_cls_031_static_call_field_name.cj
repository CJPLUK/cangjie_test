/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// CT-CLS-031: a static method call whose callee name matches an instance
// field of the enclosing type (`Utl.flag()` vs field `flag`) used to be
// misjudged by the instance-member validator as an illegal instance access
// (audit report 2 #26).
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// RUN-EXEC: %set_stdx_path %run %run_opt %n.%suffix %run_utest_opt %run_args
import stdx.contract.macros.*

class ClsGlobalNameUtl {
    public static func flag(): Bool { return true }
}

@Contract []
class ClsGlobalName {
    var flag: Int64 = 1
    @Contract [ensures r: ClsGlobalNameUtl.flag()]
    public func f(): Int64 { return 1 }
}

main() {
    let c = ClsGlobalName()
    if (c.f() != 1) {
        throw Exception("body did not run")
    }
    println("ok")
}
