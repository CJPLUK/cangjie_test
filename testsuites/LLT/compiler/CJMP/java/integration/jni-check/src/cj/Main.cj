// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Main <: JavaClass {
   public init() {
     println("in M Init")
   }

   override public func goo():Unit {
     println("in M goo")
     super.goo()
   }

   @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        print("cj: Main()\n", flush: true)
        var a = JavaClass()
        a.goo()
        print("cj: Main() end\n", flush: true)
    }
}
