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

        MainTest.executeTest()
        
        print("cj: Main() end\n", flush: true)
    }
}

@Java
public class MainTest {

}

extend MyObject {
    private prop magicK: Int32 {
        get() { 10 }
    }

    public func getNumLarger() {
        getNum() * magicK
    }
}

extend MainTest {
    static func executeTest() {
        let obj = MyObject()
        let res = obj.getNumLarger()
        print("cj: MyObject.getNumLarger() = ${res}\n", flush: true)
        if (res != obj.getNum() * 10) {
            throw Exception("MyObject.getNumLarger() has invalid value: ${res}")
        }
    }
}
