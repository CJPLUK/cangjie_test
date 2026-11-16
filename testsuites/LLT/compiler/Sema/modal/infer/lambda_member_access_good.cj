// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class B {
    var v: String
    init() { v = "hello" }
    init(this @local?) { exclave { v = "hello" } }
}

func g(x: String) {
    x
}

let f = {x => g(x.v)}

func test(): Unit {
    println(f(B()))
}

main() {
    test()
}
