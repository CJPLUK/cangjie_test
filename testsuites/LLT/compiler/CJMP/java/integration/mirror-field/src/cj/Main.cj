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
        print("cj: Main()\n", flush: true)

        let obj = MyObject(1)
        print("cj: ${obj.x} ${obj.y} ${MyObject.sx} ${MyObject.sy}\n", flush: true)
        obj.x = false
        print("cj: var x modify\n", flush: true)
        MyObject.sx = 11
        print("cj: static var sx modify\n", flush: true)
        print("cj: ${obj.x} ${obj.y} ${MyObject.sx} ${MyObject.sy}\n", flush: true)

        obj.obj = JString("set obj field")
        print("cj: ${obj.obj.toString()}\n", flush: true)

        MyObject.sobj = JString("set sobj field")
        print("cj: ${MyObject.sobj.toString()}\n", flush: true)

        print("cj: Main() end\n", flush: true)
    }
}
