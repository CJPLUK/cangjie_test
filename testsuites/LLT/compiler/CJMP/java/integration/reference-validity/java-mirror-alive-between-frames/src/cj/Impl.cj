// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

private var mirror = Option<MyObject>.None

@Java["com.java.lib.MyObject"]
public foreign class MyObject {
    public init()
    public func check(): Unit
}

@Java
public class Impl {
    public static func store(i: MyObject) {
        mirror = i
    }

    public static func storeAsOption(i: ?MyObject) {
        mirror = i
    }

    public static func get(): ?MyObject {
        return mirror
    }
}
