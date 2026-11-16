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

        testNull()
        testEmpty()
        testNonEmpty()
    }

    private func testNull() {
        print("cj: test null\n", flush: true)

        let arr = Option<JArray<JObject>>.None

        if (!isNull(arr)) {
            throw Exception("cj: null array(JObject) is non-null")
        }

        let arr2 = Option<JArray<MyObject>>.None

        if (!isNull(arr2)) {
            throw Exception("cj: null array(MyObject) is non-null")
        }

        print("cj: finish test null\n", flush: true)
    }

    private func testEmpty() {
        print("cj: test empty\n", flush: true)

        let arr = JArray<JObject>(0i32)

        if (isNull(arr)) {
            throw Exception("cj: non-null array(JObject) is null")
        }

        if (arr.length != 0) {
            throw Exception("cj: empty array(JObject) size != 0")
        }

        let arr2 = JArray<MyObject>(0i32)

        if (isNull(arr2)) {
            throw Exception("cj: non-null array(MyObject) is null")
        }

        if (arr2.length != 0) {
            throw Exception("cj: empty array(MyObject) size != 0")
        }

        print("cj: finish test empty\n", flush: true)
    }

    private func testNonEmpty() {
        print("cj: test nonEmpty\n", flush: true)

        let mirror = MyObject()
        let arrSize = 5i32
        let arr = JArray<Int32>(arrSize)
        if (arr.length != arrSize) {
            throw Exception("JArray<Int32> bad size: ${arr.length}")
        }

        arr[0] = 1
        arr[4] = 10

        print("cj: call mirror.isNull(arr)\n", flush: true)

        let isNullNotNullRes = mirror.isNull(arr)

        match (isNullNotNullRes) {
            case true => throw Exception("cj: mirror.isNull(arr) = true")
            case false => print("cj: mirror.isNull(arr) = false\n", flush: true)
        }

        print("cj: call mirror.isNull(None)\n", flush: true)

        let isNullRes = mirror.isNull(Option<JArray<Int32>>.None)

        match (isNullRes) {
            case true => print("cj: mirror.isNull(None) = true\n", flush: true)
            case false => throw Exception("cj: mirror.isNull(None) = false")
        }

        print("cj: finish test nonEmpty\n", flush: true)
    }

    private var isImplNullCalled = false

    public func wasImplNullCalled(): Bool {
        return isImplNullCalled
    }

    public func isNull(arr: ?JArray<Impl>): Bool {
        isImplNullCalled = true
        match (arr) {
            case Some(a) => print("cj: isNull(argg) = false\n", flush: true)
            case None => print("cj: isNull(argg) = true\n", flush: true)
        }
        return arr.isNone()
    }
}
