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

        let rself = mirror.self()

        match (rself) {
            case Some(s) => println("Some() has come from self(), s.check() = ${s.check()}")
            case None => throw Exception("None has come from self()")
        }

        let rselfNull = mirror.selfNull()
        match (rselfNull) {
            case Some(s) => throw Exception("Some has come from selfNull()")
            case None => println("None has come from selfNull()")
        }
    }
}
