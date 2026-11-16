// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Main <: JObject {
    @ForeignName["main"]
    public static func entry(args: JArray<JString>): Unit {
        print("CJ: before Child()\n", flush: true)
        let obj = Child()
        print("CJ: after Child()\n", flush: true)

        print("CJ: before child.foo()\n", flush: true)
        obj.foo()
        print("CJ: after child.foo()\n", flush: true)
        
        print("CJ: Main() end\n", flush: true)
    }
}
