// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

class C {
    let x: Int64 = 7
    const init(this @local!) { exclave { } }
}
const a = C().x

class D {
    let w: Int64 = 77
    const init(this @local!) { exclave { } }
}
const b = D().w

class E {
    let y: Int64 = 8
    const init(this @local?) { exclave { } }
}
const c = E().y

struct S {
    let z: Int64 = 9
    const init(this @local!) { exclave { } }
}
const d = S().z

main() {
    println(a)
    println(b)
    println(c)
    println(d)
}
/* SCAN
7
77
8
9
*/
