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

        let rself = mirror.self()

        let rcheck = mirror.check()
        if (rcheck != 5) {
            throw Exception("mirror.check() result is incorrect: ${rcheck}")
        }

        if (mirror.check() != rself.check()) {
            throw Exception("mirror.check() != rself.check()")
        }
    }
}
