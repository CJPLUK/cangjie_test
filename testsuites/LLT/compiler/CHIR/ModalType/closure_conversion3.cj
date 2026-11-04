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
// ASSERT: scan-full AAA::foo, x = S

interface III {
    static func foo<T>(x: T @local!) where T <: S {
        print("III::foo")
    }
    func goo(): (S @local!) -> Unit
}

open class S {
    init(this @local!) { exclave {} }
    public func toString(this @local!): String {
        "S"
    }
}

class AAA <: III {
    var a = 1
    public static func foo<U>(x: U @local!) where U <: S {
        exclave {
            print("AAA::foo, x = ${x.toString()}")
        }
    }
    public func goo() {
        var a = foo<S>
        return a
    }
}

main() {
    var a = S() @local!
    AAA().goo()(a)
    return 0
}