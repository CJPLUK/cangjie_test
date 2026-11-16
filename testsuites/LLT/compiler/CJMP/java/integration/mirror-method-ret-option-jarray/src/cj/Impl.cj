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

        let arr1 = getArrInt(true, 0)

        if (arr1.isSome()) {
            throw Exception("cj: null array(Int32) is non-null")
        }

        let arr2 = getArrObj(true, 0)

        if (arr2.isSome()) {
            throw Exception("cj: null array(Object) is non-null")
        }

        let arr3 = getArrMyObj(true, 0)

        if (arr3.isSome()) {
            throw Exception("cj: null array(MyObject) is non-null")
        }

        print("cj: finish test null\n", flush: true)
    }

    private func testEmpty() {
        print("cj: test empty\n", flush: true)

        let arr1 = getArrInt(false, 0)

        if (arr1.isNone()) {
            throw Exception("cj: non-null array(Int32) is null")
        }

        if (arr1.getOrThrow().length != 0) {
            throw Exception("cj: empty array(Int32) size != 0")
        }

        let arr2 = getArrObj(false, 0)

        if (arr2.isNone()) {
            throw Exception("cj: non-null array(Object) is null")
        }

        if (arr2.getOrThrow().length != 0) {
            throw Exception("cj: empty array(Object) size != 0")
        }

        let arr3 = getArrMyObj(false, 0)

        if (arr3.isNone()) {
            throw Exception("cj: non-null array(MyObject) is null")
        }

        if (arr3.getOrThrow().length != 0) {
            throw Exception("cj: empty array(MyObject) size != 0")
        }

        print("cj: finish test empty\n", flush: true)
    }

    private func testNonEmpty() {
        print("cj: test nonEmpty\n", flush: true)
        let size = 5i32

        let arr1 = getArrInt(false, size)

        if (arr1.isNone()) {
            throw Exception("cj: non-null array(Int32) is null")
        }

        if (arr1.getOrThrow().length != size) {
            throw Exception("cj: array(Int32) size != ${size}")
        }

        for (i in 0..size) {
            let expected = i * 2 + 1
            if (arr1.getOrThrow()[i] != expected) {
                throw Exception("cj: array(Int32)[${i}] != ${expected}, but equals ${arr1.getOrThrow()[i]}")
            }
        }

        let arr2 = getArrObj(false, size)

        if (arr2.isNone()) {
            throw Exception("cj: non-null array(Object) is null")
        }

        if (arr2.getOrThrow().length != size) {
            throw Exception("cj: array(Object) size != ${size}")
        }

        for (i in 0..size) {
            if (i == 0) {
                if (!(arr2.getOrThrow()[i] is MyObject)) {
                    throw Exception("cj: array(Object)[0] expected to be MyObject")
                }
                continue
            }

            // just check any call on array item is okay
            if (arr2.getOrThrow()[i].toString().isEmpty()) {
                throw Exception("cj: array(Object)[${i}] is broken")
            }
        }

        let arr3 = getArrMyObj(false, size)

        if (arr3.isNone()) {
            throw Exception("cj: non-null array(MyObject) is null")
        }

        if (arr3.getOrThrow().length != size) {
            throw Exception("cj: array(MyObject) size != ${size}")
        }

        for (i in 0..size) {
            if (!(arr3.getOrThrow()[i] is MyObject)) {
                throw Exception("cj: array(MyObject)[0] expected to be MyObject")
            }

            // just check any call on array item is okay
            if (arr3.getOrThrow()[i].toString().isEmpty()) {
                throw Exception("cj: array(MyObject)[${i}] is broken")
            }
        }

        print("cj: finish test nonEmpty\n", flush: true)
    }
}
