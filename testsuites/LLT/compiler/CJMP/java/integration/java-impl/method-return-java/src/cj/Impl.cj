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
        println("cangjie: Impl()")
    }

    public func retInt(): Int32 {
        println("cangjie: Impl.retInt()")
        return 10
    }

    public func retBool(): Bool {
        println("cangjie: Impl.retBool()")
        return true
    }

    public func retMirror(): MyObject {
        println("cangjie: Impl.retMirror()")
        MyObject()
    }

    public func retMirrorOption(): ?MyObject {
        println("cangjie: Impl.retMirrorOption()")
        MyObject()
    }

    public func retMirrorOptionNull(): ?MyObject {
        println("cangjie: Impl.retMirrorOption()")
        return None
    }

    public func retImpl(): Impl {
        println("cangjie: Impl.retImpl()")
        return this
    }

    public func retImplOption(): ?Impl {
        println("cangjie: Impl.retImplOption()")
        return this
    }

    public func retImplOptionNull(): ?Impl {
        println("cangjie: Impl.retImplOption()")
        return Option.None
    }
}
