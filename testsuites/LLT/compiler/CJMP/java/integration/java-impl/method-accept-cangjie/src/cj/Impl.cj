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

        acceptBool(true)
        acceptInt(10)
        acceptMirror(MyObject())
        acceptMirrorOption(MyObject())
        acceptImpl(this)
        acceptImplOption(this)
    }

    public func acceptInt(i: Int32): Unit {
        println("cangjie: Impl.acceptInt(${i})")
        if (i != 10) { throw Exception("i != 10") }
    }

    public func acceptBool(b: Bool): Unit {
        println("cangjie: Impl.acceptBool(${b})")
        if (!b) { throw Exception("b != true") }
    }

    public func acceptMirror(obj: MyObject): Unit {
        println("cangjie: Impl.acceptMirror(obj)")
        MyObject.check(obj)
    }

    public func acceptMirrorOption(obj: ?MyObject): Unit {
        println("cangjie: Impl.acceptMirrorOption(obj)")
        MyObject.check(obj)
    }

    public func acceptImpl(obj: Impl): Unit {
        println("cangjie: Impl.acceptImpl(obj)")
        if (obj.magic != this.magic) {
            throw Exception("impl object is broken")
        }
    }

    public func acceptImplOption(obj: ?Impl): Unit {
        println("cangjie: Impl.acceptImplOption(obj)")
        if (obj.isNone()) {
            throw Exception("impl object is None!")
        }

        if (obj?.magic != this.magic) {
            throw Exception("impl object is broken")
        }
    }
}
