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

        let impl = mirror.getImpl()

        let rcheck = impl.check()
        if (rcheck != this.check()) {
            throw Exception("impl.check() result is incorrect: ${rcheck}")
        }
    }

    public init(i: Int32) {
        println("Impl(${i})")
        if (i != 5) { throw Exception("i != 5") }
    }
}
