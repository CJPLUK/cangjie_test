// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    init() {
        x =3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

let p = C() @local!.x
let q = C() @local!.x

main() {
    println(p-q)
}
