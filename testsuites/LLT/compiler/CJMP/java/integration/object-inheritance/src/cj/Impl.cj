// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java
public class Impl <: MyObject {
    // Impl() {
    public init() {
        println("Impl()")
        println("Impl.hashCode32() = ${hashCode32()}")
        assert(hashCode32(), 100i32)
        // println("Impl.myHashCode() = ${myHashCode()}") // TODO: uncomment later

        let parent = MyObject()
        println("MyObject.hashCode32() = ${parent.hashCode32()}")
        assert(parent.hashCode32(), 10)
        println("MyObject.myHashCode() = ${parent.myHashCode()}")
        assert(parent.myHashCode(), 11)
    }

    public override func hashCode32() {
        100i32
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
