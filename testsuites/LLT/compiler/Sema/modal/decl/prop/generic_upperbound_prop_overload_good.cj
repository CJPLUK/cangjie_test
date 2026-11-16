// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface I {
    mut prop x: Int64 {
        get() { 1 }
        set(_) {}
    }
}

interface J {
    mut prop x: Int64 @local! {
        get() { 2 }
        set(_) {}
    }
}

class C <: I & J {
    var base: Int64 = 0
    init() {}
    init(this @local!) {
        exclave {
            base = 0
        }
    }
    public mut prop x: Int64 {
        get() { 11 }
        set(v) { base = v }
    }
    public mut prop x: Int64 @local! {
        get() { 22 }
        set(v) { base = v }
    }
}

func readx<U>(a: U @local!): Int64 where U <: I & J {
    exclave {
        return a.x
    }
}

func readx2<U>(a: U): Int64 where U <: I & J {
    return a.x
}

main(): Int64 {
    let c: C @local! = C()
    let rFull = readx(c)
    if (rFull != 22) {
        return 1
    }
    let c2 = C()
    let rNot = readx2(c2)
    if (rNot != 11) {
        return 2
    }
    return 0
}
