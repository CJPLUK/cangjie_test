// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Impl <: JObject {
    private let id: Int32
    public init() {
        print("Impl()\n", flush: true)
        id = 0
    }

    public init(id: Int32) {
        print("Impl(${id})\n", flush: true)
        this.id = id
    }

    public func accept1(arr: JArray<?Impl>) {
        print("cj: accept1()\n", flush: true)

        if (arr.length != 3) {
            throw Exception("cj: arr size != 3")
        }

        if (arr[0].isSome() || !arr[0].isNone()) {
            throw Exception("cj: arr[0] != null")
        }

        if (arr[2].isSome() || !arr[2].isNone()) {
            throw Exception("cj: arr[2] != null")
        }

        if (arr[1].isNone() || !arr[1].isSome()) {
            throw Exception("cj: arr[1] == null")
        }

        if (arr[1].getOrThrow().id != 55) {
            throw Exception("cj: arr[1] != 55")
        }

        print("cj: accept1() end\n", flush: true)
    }

    public func accept2(arr: JArray<?JArray<Impl>>) {
        print("cj: accept2()\n", flush: true)

        if (arr.length != 3) {
            throw Exception("cj: arr size != 3")
        }

        if (arr[0].isSome() || !arr[0].isNone()) {
            throw Exception("cj: arr[0] != null")
        }

        if (arr[2].isSome() || !arr[2].isNone()) {
            throw Exception("cj: arr[2] != null")
        }

        if (arr[1].isNone() || !arr[1].isSome()) {
            throw Exception("cj: arr[1] == null")
        }

        if (arr[1].getOrThrow().length != 1) {
            throw Exception("cj: arr[1] size != 1")
        }

        if (arr[1].getOrThrow()[0].id != 55) {
            throw Exception("cj: arr[1][0] != 55")
        }

        print("cj: accept2() end\n", flush: true)
    }

    public func accept3() {
        print("cj: accept3()\n", flush: true)

        let a = JArray<?JArray<Impl>>(3)
        a[0] = None
        a[2] = None

        a[1] = JArray<Impl>(1)
        a[1].getOrThrow()[0] = Impl(55)

        accept2(a)

        print("cj: accept3() end\n", flush: true)
    }
}
