// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java
public class Impl <: JObject {
    public init() {
        println("Impl()")

        let mirror = MyObject()

        println("cj: call mirror.acceptMirror(mirror)")
        mirror.acceptMirror(mirror)

        println("cj: call mirror.acceptInt(10)")
        mirror.acceptInt(10)

        println("cj: call mirror.acceptBool(true)")
        mirror.acceptBool(true)

        println("cj: call mirror.acceptImpl(this)")
        mirror.acceptImpl(this)
    }
}
