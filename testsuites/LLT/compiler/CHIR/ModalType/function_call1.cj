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

open class A {
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
        a
    }
    public func foo(this @~local): Int64 {
        a
    }
}

class B <: A {
    init(this @local!) {
        exclave {
            a = 4
        }
    }
    init(this @~local) {
    }
}

main() {
    var a: B @local! = B()
    var b: B = B()
    if (a.foo() == 4 && b.foo() == 3) {
        return 0
    }
    return 1
}