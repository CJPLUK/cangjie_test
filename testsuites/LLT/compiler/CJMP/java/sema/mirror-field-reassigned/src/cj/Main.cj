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
        let obj = MyObject()
        obj.x = false
        obj.y = 2
        MyObject.sx = 20
        MyObject.sy = 200
    }
}
