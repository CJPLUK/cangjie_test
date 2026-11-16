// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test

import java.lang.*

@JavaImpl["test.EchoImpl"]
public class EchoImpl {
    public init() {}

    public func testJObjectConstructor(): Unit {
        let future = spawn {
            print("[JObject constructor] ")
            let obj = JObject()
            println("OK")
        }
        future.get()
    }

    public func testJStringConstructorWithValue(): Unit {
        let future = spawn {
            print("[JString constructor with value] ")
            let str = JString("JString")
            println("OK")
        }
        future.get()
    }

    public func testJStringConstructorEmpty(): Unit {
        let future = spawn {
            print("[JString empty constructor] ")
            let str = JString("")
            println("OK")
        }
        future.get()
    }

    public func testJStringDefaultConstructor(): Unit {
        let future = spawn {
            print("[JString default constructor] ")
            let str = JString()
            println("OK")
        }
        future.get()
    }

    public func testJavaMirrorConstructor(): Unit {
        let future = spawn {
            print("[JavaMirror constructor] ")
            let mirror = EchoMirror()
            println("OK")
        }
        future.get()
    }

    public func testFieldGetter(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[field getter] ")
            let value = mirror.objField
            println("OK")
        }
        future.get()
    }

    public func testFieldSetter(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[field setter] ")
            let value = JString("String1")
            mirror.objField = value
            println("OK")
        }
        future.get()
    }

    public func testNullableFieldSetter(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[nullable field setter] ")
            mirror.objField = None
            println("OK")
        }
        future.get()
    }

    public func testJavaMethodCall(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[Java method call] ")
            mirror.foo(23)
            println("OK")
        }
        future.get()
    }

    public func testJavaMethodReturningObject(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[Java method with object argument and object result] ")
            let result = mirror.goo(mirror)
            println("OK")
        }
        future.get()
    }

    public func testJArrayConstructor(): Unit {
        let future = spawn {
            print("[JArray constructor] ")
            let array = JArray<Int64>(3)
            println("OK")
        }
        future.get()
    }

    public func testJArrayGetSet(): Unit {
        let array = JArray<Int64>(3)
        let future = spawn {
            print("[JArray get/set] ")
            array[0] = 10
            array[1] = 20
            array[2] = 30
            let first = array[0]
            let second = array[1]
            let third = array[2]
            let length = array.length
            println("OK")
        }
        future.get()
    }

    public func testJArrayMethod(): Unit {
        let array = JArray<Int64>(3)
        let future = spawn {
            print("[JArray method] ")
            let hash = array.hashCode32()
            println("OK")
        }
        future.get()
    }

    public func testInheritedJavaMethod(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[inherited Java method] ")
            let result = mirror.inheritedFoo(23)
            if (result == 33) {
                println("OK")
             } else {
                println("FAILED: unexpected result")
            }
        }
        future.get()
    }

    public func testJavaExceptionPropagation(): Unit {
        let mirror = EchoMirror()
        let future = spawn {
            print("[Java exception propagation] ")
            try {
                mirror.throwJavaException()
                println("UNEXPECTED_SUCCESS")
            } catch (e: Exception) {
                println("Caught Java exception: ${e.toString()}")
            }
        }
        future.get()
    }
}
