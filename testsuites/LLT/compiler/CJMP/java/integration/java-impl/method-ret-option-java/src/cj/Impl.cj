// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Impl <: JObject {
    public init() {
        print("cangjie: Impl()\n", flush: true)
    }


    public func getSelfNone(): ?Impl {
        print("cangjie: getSelfNone()\n", flush: true)
        return None
    }

    public func getSelf(): ?Impl {
        print("cangjie: getSelf()\n", flush: true)
        return this
    }

    public func getSelfSome(): ?Impl {
        print("cangjie: getSelfSome()\n", flush: true)
        return Some(this)
    }


    public func getObjNone(): ?MyObject {
        print("cangjie: getObjNone()\n", flush: true)
        return None
    }

    public func getObj(): ?MyObject {
        print("cangjie: getObj()\n", flush: true)
        return MyObject()
    }

    public func getObjSome(): ?MyObject {
        print("cangjie: getObjSome()\n", flush: true)
        return Some(MyObject())
    }

    
    public func check() {
        return 6
    }

}
