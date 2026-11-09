// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output -Woff all
// RUN-EXEC: %run %run_opt %output %run_args | compare %f

open class A {
    var a = 1
    init(this @local?) {
        exclave {
            a = 2
        }
    }
    public func foo(this @local?): Int64 {
        a
    }
}

class B <: A {
    init(this @local?) {
        exclave {
            a = 4
        }
    }
}

main() {
    var a: B @local? = B()
    var b = B()
    println("a = ${a.foo()}")
    println("b = ${b.foo()}")
    0
}

/* SCAN
a = 4
b = 4
*/
