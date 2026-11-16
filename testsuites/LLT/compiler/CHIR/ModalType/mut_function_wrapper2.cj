// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %n.cj -o %output
// EXEC-PIPE-0: %run %output
// EXEC: %compiler %local %n.cj %enableO2 -o %output
// EXEC-PIPE-0: %run %output

interface III {
    func goo(this @local?): Int64 {
        return 1
    }
    func foo(this @local!): Int64 {
        goo() + 10
    }
    func foo(this @~local): Int64 {
        goo() + 20
    }
    mut func foo(x: AAA @local!): Int64 {
        exclave {
            goo() + x.goo()
        }
    }
    mut func foo(x: AAA @~local): Int64 {
        goo() * 10 + x.goo() * 10
    }
}

struct AAA <: III {
    var a = 1
    init(this @local!) {
        exclave {
            a = 2
        }
    }
    init(this @~local) {
        a = 3
    }
}

main() {
    var a: III @local! = AAA()
    var b: III = AAA()
    let c: AAA @local! = AAA()
    let d: AAA = AAA()
    if (a.foo() == 11 && b.foo() == 21 && b.foo(c) == 2 && b.foo(d) == 20) {
        return 0
    }
    return 1
}