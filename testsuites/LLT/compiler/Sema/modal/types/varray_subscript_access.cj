// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args | compare %f

struct S {
    var p = 18
    init() {}
    exclave init(this @local!) { p = 19 }
}
func f() {
    var v: VArray<S, $2> @local! = [S() @local!, S() @local!]
    let x = v[0].p
    println("${v[0].p}, ${v[1].p}")
}

main() {
    f()
}
/* SCAN
19, 19
*/