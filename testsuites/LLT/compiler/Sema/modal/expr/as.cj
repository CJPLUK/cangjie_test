// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args | compare %f

open class A {
    init() {}
    exclave init(this @local!) {}
}
class B <: A {
    func bad(this @local!) {
        println("bar")
    }

    init() {}
    exclave init(this @local!) {}
}

exclave func foo(a: A @local!) {
    let b: ?B @local! = a as B
    if (let Some(b) <- b) {
        b.bad()
    }
    let c = a as B
    if (let Some(c) <- c) {
        c.bad()
    }
}
exclave func bar(a: A@local!) {
    if (a is B) {
        println("haha")
    }
}
exclave func jet(a: Any @local!) {
    if (a is B) {
        println("jet")
    }
}

main() {
    let a = B() @local!
    foo(a)
    bar(a)
    jet(a)
    0
}
/* SCAN
bar
bar
haha
jet
*/
