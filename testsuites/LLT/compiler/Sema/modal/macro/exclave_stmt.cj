// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: %n.macro.cj
// EXEC: %compiler %local %cmp_macro %n.macro.cj
// EXEC: %run_macro %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

import exclave_stmt_macro.*

class F {
    var p = 1
    init(this @local!) { exclave { } }
}

@M
func foo(a: F @local!): F @local! {
    exclave {
        a.p = a.p + 1
        a
    }
}

main() {
    let h: F @local! = F()
    foo(h)
    println(h.p)
}
/* SCAN
2
*/
