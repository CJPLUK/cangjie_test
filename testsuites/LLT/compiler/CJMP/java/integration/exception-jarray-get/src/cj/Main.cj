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
    public static func entryPoint(args: JArray<JString>): Unit {
        print("cj: Main()\n", flush: true)

        let arr = JArray<?JObject>(1i32)
        
        let elemFirst = arr[0] // ok
        print("cj: arr[0] - ok\n", flush: true)

        let elemSecond = arr[1] // index out of bounds
        print("cj: arr[1] - BAD\n", flush: true) // should not be printed due to exception occurred
    }
}
