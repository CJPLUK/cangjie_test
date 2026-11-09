// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    static mut prop p: Int64 {
        get() { 1 }
        set(v) {}
    }
    static mut prop r: String @local! {
        get() { exclave { "x" } }
        set(v) {}
    }
}

extend C {
    static mut prop q: String @local! {
        get() { exclave { "y" } }
        set(v) {}
    }
}

extend Int {
    static prop s: String @local! {
        get() { exclave { "z" } }
    }
}
extend Float64 {
    static prop t: String @local! {
        get() { exclave { "w" } }
    }
}

func foo(): String @local! {
    exclave { "x" }
}

main() {
    let a: Int64 = C.p
    let b: String @local! = C.r
    let c: String @local! = C.q
    let d: String @local! = Int.s
    let e: String @local! = Float64.t
    C.p = 2
    C.r = "u"
    C.q = "v"
}
