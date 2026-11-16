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
        print("Main()\n", flush: true)

        let obj = MyObject(false).throwing()
    }
}
