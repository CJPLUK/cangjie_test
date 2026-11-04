// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

struct S {
    var x: Int64 = 0
    init() {}
    init(this @local!) { exclave { x = 0 } }
}

func f() {
    var v: VArray<S, $2> @local! = [S() @local!, S() @local!]
    var s: S @local! = S() @local!
    v[0] = s
}

func copyAssign() {
    var full: VArray<Int64, $2> @local! = [1, 2]
    var half: VArray<Int64, $2> @local? = [3, 4]
    full[0] = 10
    half[0] = 20
}

main() {
    f()
    copyAssign()
}
