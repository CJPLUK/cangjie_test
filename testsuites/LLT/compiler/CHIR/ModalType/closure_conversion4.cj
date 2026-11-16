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
// ASSERT: scan-full goo2, y = S?\ngoo2, z = S?

open class S {
    init(this @local!) { exclave {} }
    public func toString(this @local?): String {
        "S?"
    }
}

func foo<T>(x: T @local!) where T <: S {
    func goo1(y: T @local?): Unit {
        @local? func goo2(z: T @local?): Unit {
            println("goo2, y = ${y.toString()}")
            println("goo2, z = ${z.toString()}")
        }
        goo2(y)
        }
    exclave {
        goo1(x)
    }
}

main() {
    var a = S() @local!
    foo(a)
    return 0
}