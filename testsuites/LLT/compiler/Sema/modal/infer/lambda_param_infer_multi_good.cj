// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Several unannotated lambda parameters each adopt the @local! modal of the callee's formals.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func take(a: C @local!, b: C @local!): String {
    "both"
}

func run() {
    let f = { x, y => exclave { take(x, y) } }
    let c: C @local! = C()
    println(f(c, c))
}

main() {
    run()
}

/* SCAN
both
*/
