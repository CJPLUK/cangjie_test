// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args | compare %f

exclave func foo(a: (Int64)->String @local!) {
    func bar(x: String @local!) {
        x.size
    }
    a ~> bar
}
exclave func goo(a: (Int64)->String @local!): ((Int)->Int) {
    func bar(x: String @local!) {
        x.size
    }
    a ~> bar
}

main() {
    let g = 777
    let r = g |> foo {
        x => x.toString()
    }
    let r2 = g |> goo {
        x => x.toString()
    }
    println("${r} ${r2}")
}
/* SCAN
3 3
*/