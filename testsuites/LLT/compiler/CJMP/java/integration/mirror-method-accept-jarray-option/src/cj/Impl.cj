// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*


@Java
public class Impl <: MyObject {
    public init() {
        print("Impl()\n", flush: true)

        testEmpty()
        testNulls()
        testNotNulls()
    }

    private func testEmpty() {
        print("cj: test empty\n", flush: true)
        let arr = JArray<?JObject>(0i32)
        if (arr.length != 0i32 || getSize(arr) != 0i32) {
            throw Exception("cj: non-empty array")
        }

        if (hasNull(arr)) {
            throw Exception("cj: empty array has null")
        }
    }

    private func testNulls() {
        print("cj: test nulls\n", flush: true)
        let size = 5i32
        let mirror = MyObject()
        let arr = JArray<?JObject>(size)

        let x = arr[0]
        print("x == null? ${x.isNone()}\n", flush: true)

        for (i in 0i32..size) {
            arr[i] = Option<JObject>.None
        }

        if (arr.length != size || mirror.getSize(arr) != size || getSize(arr) != size) {
            throw Exception("cj: bad array size")
        }

        if (!mirror.hasNull(arr) || !hasNull(arr)) {
            throw Exception("cj: array of nulls has non-null")
        }

        for (i in 0..arr.length) {
            let opt = arr[i]
            if (!isNull(opt)) {
                throw Exception("cj: array of nulls has non-null")
            }
        }

        print("cj: finish test nulls\n", flush: true)
    }

    private func testNotNulls() {
        print("cj: test notNulls\n", flush: true)
        let size = 5i32
        let mirror = MyObject()
        let arr = JArray<?JObject>(size)

        let x = arr[0]
        print("x == null? ${x.isNone()}\n", flush: true)

        for (i in 0i32..size) {
            arr[i] = if (i % 2 == 0) { JObject() } else { MyObject() }
        }

        if (arr.length != size || mirror.getSize(arr) != size || getSize(arr) != size) {
            throw Exception("cj: bad array size")
        }

        if (mirror.hasNull(arr) || hasNull(arr)) {
            throw Exception("cj: array of non-nulls has null")
        }

        for (i in 0..arr.length) {
            let opt = arr[i]
            if (isNull(opt)) {
                throw Exception("cj: array of non-nulls has null")
            }
        }

        print("cj: finish test notNulls\n", flush: true)
    }
}
