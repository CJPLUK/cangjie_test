// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

private var impl = Option<Impl>.None

@Java
public class Impl {
    private let msg = "cangjie: Impl"

    public static func store(i: Impl) {
        impl = i
    }

    public static func storeAsOption(i: ?Impl) {
        impl = i
    }

    public static func get(): ?Impl {
        return impl
    }

    public func check() {
        println(msg, flush: true)
    }
}

private func println<T>(value: T, flush!: Bool = false) where T <: ToString {
    print("${value.toString()}\n", flush: flush)
}
