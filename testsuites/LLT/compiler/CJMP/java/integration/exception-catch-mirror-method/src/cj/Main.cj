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

        testCatchingCtor()
        testCatchingMethod()
    }

    private static func testCatchingCtor() {
        print("cj: catching ctor test\n", flush: true)

        var caught = false
        try {
            let obj = MyObject(true)
            eprintln("FAIL")
            throw Exception("cj: MyObject(true) did not throw")
        } catch(e: Exception) {
            caught = true
        }

        if (!caught) {
            eprintln("FAIL")
            throw Exception("cj: MyObject(true) was not caught")
        }

        print("cj: finish catching ctor test\n", flush: true)
    }

    private static func testCatchingMethod() {
        print("cj: catching method test\n", flush: true)
        let obj = MyObject(false)

        var caught = false
        try {
            obj.throwing()
            eprintln("FAIL")
            throw Exception("cj: obj.throwing() did not throw")
        } catch(e: Exception) {
            caught = true
        }

        if (!caught) {
            eprintln("FAIL")
            throw Exception("cj: obj.throwing() was not caught")
        }

        print("cj: finish catching method test\n", flush: true)
    }
}
