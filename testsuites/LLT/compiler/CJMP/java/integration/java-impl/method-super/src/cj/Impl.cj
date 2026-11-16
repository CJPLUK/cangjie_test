// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Impl <: MyObject {
    public init() {
        print("cangjie: Impl()\n", flush: true)

        let res = super.foo()

        testFooUnit()
        testBarInt()
        testFooInt()
        testFooString()
        testFooMyObject()
        testFooMyObjectNull()
    }

    public func testFooUnit(): Unit {
        print("cangjie: test void foo()\n", flush: true)

        super.foo()

        print("cangjie: test void foo() end\n", flush: true)
    }

    public func testBarInt(): Unit {
        print("cangjie: test int bar()\n", flush: true)

        let res = super.bar()

        if (res != 15) {
            throw Exception("cj: res(${res}) != 15")
        }

        print("cangjie: test int bar() end\n", flush: true)
    }

    public func testFooInt(): Unit {
        print("cangjie: test int foo(int)\n", flush: true)

        let arg = 33i32
        let res = super.foo(arg)

        if (arg != res) {
            throw Exception("cj: arg(${arg}) != res(${res})")
        }

        print("cangjie: test int foo(int) end\n", flush: true)
    }

    public func testFooString(): Unit {
        print("cangjie: test String foo(String)\n", flush: true)

        let arg = JString("Hello cangjie - java")
        let res = super.foo(arg)

        if (!arg.equals(res)) {
            throw Exception("cj: arg(${arg.toString()}) != res(${res.toString()})")
        }

        print("cangjie: test String foo(String) end\n", flush: true)
    }

    public func testFooMyObject(): Unit {
        print("cangjie: test MyObject foo(MyObject)\n", flush: true)

        let arg1 = (this as MyObject).getOrThrow()
        let res1 = super.foo(arg1)

        let arg1test = arg1.testValue()
        let res1test = res1.getOrThrow().testValue()
        if (arg1test != res1test) {
            throw Exception("cj: arg(${res1test}) != res(${res1test})")
        }

        let arg2 = this
        let res2 = super.foo(arg2)

        let arg2test = arg2.testValue()
        let res2test = res2.getOrThrow().testValue()
        if (arg2test != res2test) {
            throw Exception("cj: arg(${res2test}) != res(${res2test})")
        }

        let arg3 = MyObject()
        let res3 = super.foo(arg3)

        let arg3test = arg3.testValue()
        let res3test = res3.getOrThrow().testValue()
        if (arg3test != res3test) {
            throw Exception("cj: arg(${res3test}) != res(${res3test})")
        }

        print("cangjie: test MyObject foo(MyObject) end\n", flush: true)
    }

    public func testFooMyObjectNull(): Unit {
        print("cangjie: test MyObject foo(MyObject - null)\n", flush: true)

        let arg = Option<MyObject>.None
        let res = super.foo(arg)

        if (res.isSome() || !res.isNone()) {
            throw Exception("cj: arg(None) != res(Some(MyObject))")
        }

        print("cangjie: test MyObject foo(MyObject - null) end\n", flush: true)
    }

    public override func foo(): Unit {
        throw Exception("cj: Impl.foo(): Unit called")
    }

    public override func bar(): Int32 {
        throw Exception("cj: Impl.bar(): Int32 called")
    }

    public func foo(a: Int32): Int32 {
        throw Exception("cj: Impl.foo(): Int32 called")
    }

    public func foo(a: JString): JString {
        throw Exception("cj: Impl.foo(): JString called")
    }

    public func foo(a: ?MyObject): ?MyObject {
        throw Exception("cj: Impl.foo(): ?MyObject called")
    }
}
