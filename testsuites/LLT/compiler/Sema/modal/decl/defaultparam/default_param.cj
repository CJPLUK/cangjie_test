// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args
class D {
    var c: C
    init(c: C){
        this.c = c
    }
    exclave init(this @local!, c: C@local!) {
        this.c = c
    }
}

class C {
    init() {
        p = "hello"
    }
    exclave init(this @local!) {
        p = "right"
    }
    var p: String
}

exclave func foo(d: D@local!, v: String @local!, c!: C@local! = C()) {
    d.c = c
    c.p = c.p + v
}

func bar() {
    let d = D(C() @local!) @local!
    foo(d, "world")
}
main() {
    bar()
}