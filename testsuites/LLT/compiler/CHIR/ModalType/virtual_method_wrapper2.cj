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

struct S {
    var a = 1
    init(this @local!, b: Int64) {
        exclave {
            a = b
        }
    }
    init(this @~local, b: Int64) {
        a = b + 10
    }
    operator func +(this @local!, y: S): S @local? {
        exclave {
            S(a + y.a) @local!
        }
    }
}

interface III<T> {
    func foo(x: T @local!): T @local?
}

class AAA <: III<S> {
    public func foo(x: S @local!): S @local? {
        exclave {
            x + S(10)
        }
    }
}

main() {
    var a: III<S> = AAA()
    var b: S @local! = S(15)
    if (a.foo(b).a == 35) {
        return 0
    }
    return 1
}