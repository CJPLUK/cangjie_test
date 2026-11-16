// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class F {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}
class G <: F {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

func foo(a: F@local!): Int {
    match (a) {
        case x: G => 1
        case _ => 0
    }
}

func bar(a: F@~local): Int {
    match (a) {
        case x: G => 1
        case _ => 0
    }
}
func baz(a: F@local?): Int {
    match (a) {
        case x: G => 1
        case _ => 0
    }
}

func getf(): F@local! {
    exclave {
        F()
    }
}
func gg() {
    let f: F@local! = getf()
    match (f) {
        case x: G => 1
        case _ => 0
    }
}
main() {
    let a: F@local! = G()
    foo(a)
    let b: F@~local = G()
    bar(b)
    let c: F@local? = a
    baz(c)
    getf()
    gg()
    0
}
