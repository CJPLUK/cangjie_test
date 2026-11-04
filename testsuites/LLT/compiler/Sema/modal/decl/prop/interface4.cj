// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct Dem<T> {
    demode var v: T
    init(a: T) {
        v = a 
    }
    exclave init(this @local!, a: T) {
        v = a
    }
}
interface I<T> {
    mut prop x: String @local!
    prop car: Dem<()->String @local!> @local? {
        get() {
            exclave {
                Dem({ => exclave { let b:String @local! = "ham"; return b }} ) @local!
            }
        }
    }
}

exclave func foo<T>(value: T @local!) where T <: I<String> {
    var gm = value
    let str = value.x
    gm.x = value.car.v()
    let b = value.car.v()
    str.size - b.size
}

class B <: I<String> {
    private var k: String

    init() {
        k = ""
    }
    exclave init(this @local!) {
        k = ""
    }
    public mut prop x: String @local! {
        get() { exclave {k} }
        set(value) {
            exclave {
                k = value
            }
        }
    }
}
main() {
    let b: I<String> @local! = B()
    b.x = "gem"
    foo(b)
}