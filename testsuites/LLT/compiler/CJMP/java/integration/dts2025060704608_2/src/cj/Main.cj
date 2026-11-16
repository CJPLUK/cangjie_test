// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Main <: JavaClass {
    @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        print("cj: Main()\n", flush: true)

        var javaClass = JavaClass()
        var v1 = javaClass.goo(javaClass.foo())
        print("JavaClass inherit goo: ${v1}\n", flush: true)
        var _v2 = I1.bar()
        print("I1 bar: ${_v2}\n", flush: true)
        var v2 = JavaClass.bar()
        print("JavaClass inherit bar: ${v2}\n", flush: true)
        var v3 = javaClass.goo()
        print("JavaClass new goo: ${v3}\n", flush: true)
        var v4 = JavaClass.bar(1234)
        print("JavaClass new bar: ${v4}\n", flush: true)
        
        print("cj: Main() end\n", flush: true)
    }
}
