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
    func foo(this @local!): Int64
    func foo(this @~local): Int64
    func foo(x: AAA @local!): Int64
    func foo(x: AAA @~local): Int64
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
    public func foo(this @local!): Int64 {
        a + 10
    }
    public func foo(this @~local): Int64 {
        a + 20
    }
    public func foo(x: AAA @local!): Int64 {
        x.a + 30
    }
    public func foo(x: AAA @~local): Int64 {
        x.a + 40
    }
}

main() {
    var a: III @local! = AAA()
    var b: III = AAA()
    let c: AAA @local! = AAA()
    let d: AAA = AAA()
    if (a.foo() == 12 && b.foo() == 23 && b.foo(c) == 32 && b.foo(d) == 43) {
        return 0
    }
    return 1
}