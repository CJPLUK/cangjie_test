// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class G {
    var x: Int64 = 42
    init() {}
    init(this @local!) { exclave {} }
}

exclave func makeG(): G @local! {
    G()
}

class A {
    static init() {
        func f(p: G @local!): Unit {
            exclave {
                print("static init local func: ${p.x}")
            }
        }
        let lam = { p: G @local! => exclave { print("static init lambda: ${p.x}") } }
        let g = makeG()
        f(g)
        lam(g)
    }
    ~init() {
        func f(p: G @local!): Unit {
            exclave {
                print("finalizer local func: ${p.x}")
            }
        }
        let lam = { p: G @local! => exclave { print("finalizer lambda: ${p.x}") } }
        let g = makeG()
        f(g)
        lam(g)
    }
}
func bar() {
    spawn {
        func foo(): String @local! {
            exclave { "haha" }
        }
        let lam: ()->String @local! = { => exclave {"bet"} }
    }
}

main(): Int64 {
    func f(p: G @local!): Unit {
        exclave {
            print("main local func: ${p.x}")
        }
    }
    let lam = { p: G @local! => exclave { print("main lambda: ${p.x}") } }
    let g = makeG()
    f(g)
    lam(g)
    A()
    0
}
