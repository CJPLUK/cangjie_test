// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An unannotated lambda parameter in the func-argument position adopts the @local! modal
// of the callee's formal.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func take(c: C @local!): String {
    "full"
}

func apply(f: (C @local!) -> String) {
    let c: C @local! = C()
    println(f(c))
}

func run() {
    apply({ x => exclave { take(x) } })
}

main() {
    run()
}

/* SCAN
full
*/
