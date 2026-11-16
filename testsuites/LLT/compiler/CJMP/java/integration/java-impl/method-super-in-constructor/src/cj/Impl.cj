// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Impl <: Base {
    public init() {
        print("cj: A()\n", flush: true)
        super.foo(10)
        super.bar()
        print("cj: end A()\n", flush: true)
    }

    public override func foo(i: Int64): Int64 {
        print("cj: foo(${i})\n", flush: true)
        return i - 1
    }

    public override func bar(): Bool {
        print("cj: bar()\n", flush: true)
        return false
    }

    @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        print("cj: main()\n", flush: true)

        let impl = Impl()
        impl.foo(10)
        impl.bar()

        print("cj: end main()\n", flush: true)
    }
}
