// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class Impl <: MyObject {
    private let id: Int64

    public init(id: Int64) {
        print("Impl(${id})\n", flush: true)
        this.id = id
    }

    public init() {
        print("Impl()\n", flush: true)
        this.id = 0
    }

    public func accept1(a: JArray<?JArray<JArray<Impl>>>) {
        print("cj: accept1()\n", flush: true)
        if (a.length != 2) {
            throw Exception("cj: accept1 arr size != 2")
        }

        if (a[0].isSome()) {
            throw Exception("cj: accept1 arr[0] != null")
        }

        if (a[1].isNone()) {
            throw Exception("cj: accept1 arr[0] != null")
        }

        if (a[1].getOrThrow().length != 1) {
            throw Exception("cj: accept1 arr[1] size != 1")
        }

        if (a[1].getOrThrow()[0].length != 2) {
            throw Exception("cj: accept1 arr[1][0] size != 2")
        }

        if (a[1].getOrThrow()[0][0].id != 55) {
            throw Exception("cj: accept1 arr[1][0][0] != 55")
        }
        if (a[1].getOrThrow()[0][1].id != 110) {
            throw Exception("cj: accept1 arr[1][0][1] != 110")
        }
        print("cj: accept1() end\n", flush: true)
    }

    public func return1(): JArray<?JArray<JArray<Impl>>> {
        print("cj: return1()\n", flush: true)
        let a = JArray<?JArray<JArray<Impl>>>(2)
        a[0] = None
        a[1] = JArray<JArray<Impl>>(1)
        a[1].getOrThrow()[0] = JArray<Impl>(2)
        a[1].getOrThrow()[0][0] = Impl(55)
        a[1].getOrThrow()[0][1] = Impl(110)

        accept1(a)
        print("cj: return1() end\n", flush: true)
        return a
    }
}
