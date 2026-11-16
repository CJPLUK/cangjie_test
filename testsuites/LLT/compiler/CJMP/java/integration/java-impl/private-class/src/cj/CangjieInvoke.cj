/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package cj

import java.lang.*

@Java["com.JavaClass"]
private foreign abstract class JavaClass {
    public init()
    public open func goo(): Int32
    public static func bar(): Int32
    public abstract func newoo(): Int32
}

// Checks that private @Java class is functional

@Java
private class TestClass <: JavaClass {
    public init() {
        super()
        print("in TestClass Init\n", flush: true)
    }

    public override func goo() {
        print("in TestClass goo\n", flush: true)
        return 88i32
    }

    public static redef func bar() {
        print("in TestClass bar\n", flush: true)
        return 54321i32
    }

    public func newoo(): Int32 {
        print("in CangjieInvoke newoo\n", flush: true)
        return 12345
    }
}

@Java
public class CangjieInvoke <: JObject {
    public init() {
        print("in CangjieInvoke Init\n", flush: true)
        var testclass = TestClass()
        print("testclass.goo(): ${testclass.goo()}\n", flush: true)
        print("testclass.newoo(): ${testclass.newoo()}\n", flush: true)
        print("TestClass.bar(): ${TestClass.bar()}\n", flush: true)
        print("JavaClass.bar(): ${JavaClass.bar()}\n", flush: true)
    }
}
