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
        println("Impl()")

        let mirror = MyObject()

        println("cj: call mirror.isNull(mirror)")

        let isNullNotNullRes = mirror.isNull(mirror)

        match (isNullNotNullRes) {
            case true => throw Exception("mirror.isNull(mirror) = true")
            case false => println("mirror.isNull(mirror) = false")
        }

        println("cj: call mirror.isNull(None)")

        let isNullRes = mirror.isNull(None)

        match (isNullRes) {
            case true => println("mirror.isNull(None) = true")
            case false => throw Exception("mirror.isNull(None) = false")
        }
    }
}
