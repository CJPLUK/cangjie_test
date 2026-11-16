// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.JImpl"]
open foreign class JImpl <: JObject {
    public init()
    public func takeArr(arr: JArray<Int64>): Unit
    public func takeArr(arr: ?JArray<Int32>): Unit
    public func getArr(): JArray<Int64>
    public func getArrInt(): JArray<Int32>
    public func takeArr2(arr: JArray<JImpl>): Unit
    public func getArr2(): JArray<JImpl>
    public func getInt(): Int64
}

class Bar <: ToString {
    public func toString() { "this is Bar" }
}

@Java
public class Impl <: JImpl {
    public func foo(): JArray<Int64> {
        JArray<Int64>(44)
    }

    public init() {
        println("cangjie: Impl()")

        let arr0 = JArray<Float64>(5)
        arr0[4] = 1.00033
        arr0[1] = -9.554
        println("cangjie: 5th of F64 array - " + arr0[4].toString())
        println("cangjie: 2nd of F64 array - " + arr0[1].toString())
        println("cangjie: length of F64 array - " + arr0.length.toString())

        let arr1 = JArray<JImpl>(9)
        arr1[1] = JImpl()
        println("cangjie: 2nd of JImpl array - " + arr1[1].getInt().toString())
        println("cangjie: length of JImpl array - " + arr1.length.toString())

        let arr2 = getArr()
        println("cangjie: 1st of I64 array - " + arr2[0].toString())
        println("cangjie: 2nd of I64 array - " + arr2[1].toString())
        println("cangjie: 3rd of I64 array - " + arr2[2].toString())
        arr2[2] = 73
        takeArr(arr2)

        let arr3 = getArr2()
        println("cangjie: 1st of JImpl array from Java - " + arr3[0].getInt().toString())
        println("cangjie: 2nd of JImpl array from Java - " + arr3[1].getInt().toString())
        println("cangjie: 3rd of JImpl array from Java - " + arr3[2].getInt().toString())
        arr3[2] = JImpl()
        takeArr2(arr3)

        let arr4 = this.foo()
        println("cangjie: length of I64 array - " + arr4.length.toString())

        let arr5 = getArr()
        println("cangjie: 1st of I32 array - " + arr5[0].toString())
        println("cangjie: 2nd of I32 array - " + arr5[1].toString())
        println("cangjie: 3rd of I32 array - " + arr5[2].toString())
        arr5[2] = 73
        takeArr(arr5)
    }
}
