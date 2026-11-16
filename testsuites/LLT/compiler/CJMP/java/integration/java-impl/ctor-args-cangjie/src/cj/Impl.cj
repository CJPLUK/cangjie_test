// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java
public class Impl <: MyObject {
    public init() {
        println("cangjie: Impl()")

        let impl1 = Impl(5, true)
        let impl2 = Impl(FakeObject(), MyObject())
        let impl3 = Impl(FakeObject())
        let impl4 = Impl(Option<JObject>.None)
        let impl5 = Impl(15)
    }

    public init(a: Int64) {
        println("cangjie: Impl(${a})")
        assert(a, 15)
    }

    public init(a: Int64, b: Bool) {
        println("cangjie: Impl(${a}, ${b})")
        assert(a, 5)
        assert(b, true)
        Impl(Option<JObject>.None)
    }

    public init(obj: JObject, myobj: MyObject) {
        println("cangjie: Impl(JObject, MyObject)")
        assert(myobj.isValid(), true)
        assert(obj.hashCode32(), 5)
    }

    public init(arg: ?JObject) {
        println("cangjie: Impl(?JObject - ${if (arg.isSome()) { "not " } else { "" } + "null" }})")
        match (arg) {
            case Some(obj) => assert(obj.hashCode32(), 5)
            case _ => ()
        }
    }
}

func assert<T>(left: Equatable<T>, right: T) {
    if (left != right) {
        let str = if (left is ToString && right is ToString) {
            "${(left as ToString).getOrThrow()} != ${(right as ToString).getOrThrow()}"
        } else {
            "values must be equal"
        }
        throw Exception("Assertion failed: ${str}")
    }
}
