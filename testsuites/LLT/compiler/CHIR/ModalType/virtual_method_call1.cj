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

open class AAA {
    var a = 1
    init(this @local!) {
        exclave {
            a = 2
        }
    }
    init(this @~local) {
        a = 3
    }
    public open func foo(this @local!): Int64 {
        a + 10
    }
    public open func foo(this @~local): Int64 {
        a + 20
    }
    public open func foo(x: AAA @local!): Int64 {
        x.a + 30
    }
    public open func foo(x: AAA @~local): Int64 {
        x.a + 40
    }
}

open class BBB <: AAA {
    init(this @local!) {
        exclave {
            a = 4
        }
    }
    init(this @~local) {
    }
}

main() {
    var a: AAA @local! = BBB()
    var b: AAA = BBB()
    if (a.foo() == 14 && b.foo() == 23 && b.foo(a) == 34 && b.foo(b) == 43) {
        return 0
    }
    return 1
}