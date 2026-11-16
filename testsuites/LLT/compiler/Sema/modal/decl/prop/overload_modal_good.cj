// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    init() {}
    init(this @local!) {
        exclave {}
    }
    mut prop v: Int64 {
        get() { 1 }
        set(_) { }
    }
    mut prop v: Int64 @local! {
        get() { 2 }
        set(_) { }
    }
}

main() {
    let c: C @~local = C()
    let a = c.v
    println(a)
    c.v = 8

    let d: C @local! = C()
    let b = d.v
    println(b)
    d.v = 9
}
