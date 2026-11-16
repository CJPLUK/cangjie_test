// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java
public class Impl <: JObject {
    private let magic = 55

    public init() {
        println("cangjie: Impl()")
    }

    public func foo(i: Int32): Unit {
        println("cangjie: Impl.fooInt(${i})")
        if (i != 10) { throw Exception("i != 10") }
    }

    public func foo(b: Bool): Unit {
        println("cangjie: Impl.fooBool(${b})")
        if (!b) { throw Exception("b != true") }
    }

    public func foo(obj: MyObject): Unit {
        println("cangjie: Impl.fooMirror(obj)")
        MyObject.check(obj)
    }

    public func foo(obj: Impl): Unit {
        println("cangjie: Impl.fooImpl(obj)")
        if (obj.magic != this.magic) {
            throw Exception("impl object is broken")
        }
    }
}
