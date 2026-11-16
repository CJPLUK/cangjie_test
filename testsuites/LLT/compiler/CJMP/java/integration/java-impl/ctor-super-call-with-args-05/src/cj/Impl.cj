// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

/**
 * Testing for expr using parameters of init.
 * DTS
 */

import java.lang.*

func globalFunction1(p: JArray<Float32>): Int8   {
    1i8
}
func globalFunction2(p: Int8): JArray<Float32>   {
    var res = JArray<Float32>(1)
    res[0] = 2.0f32
    res
}
func globalFunction3(p: JArray<Float64>): JArray<Int32> {
    var res = JArray<Int32>(1)
    res[0] = 3i32
    res    
}
func globalFunction4(p: Int8): JArray<Float64>   {
    var res = JArray<Float64>(1)
    res[0] = 4.0
    res
}

func globalFunction1(p: JArray<Int8>): Int32   {
    1i32
}
func globalFunction2(p: Int32): Float32   {
    114.514000f32
}
func globalFunction3(p: Float32): JArray<Int8>   {
    var res = JArray<Int8>(1)
    res[0] = 33
    res
}
func globalFunction4(p: Int32): Int16   {
    4i16
}


@Java
public class Impl <: MyObject {
    // Test Case2: call global func
    public init(param0: JArray<Int32>, param1: Int8, param2: JArray<Float64>, param3: JArray<Float32>, param4: JArray<Float32>) {
        super(globalFunction1(param3), globalFunction2(param1), globalFunction3(param2), globalFunction4(param1))
    }

    // Test Case3: call global func
    public init(param0: Int16, param1: Int32, param2: Float32, param3: JArray<Int8>, param4: JArray<Int8>) {
        super(globalFunction1(param3), globalFunction2(param1), globalFunction3(param2), globalFunction4(param1))
    }

    // Test Case4: simple expr
    public init(param0: JArray<Float32>, param1: Int32, param2: JArray<Int8>, param3: JArray<UInt16>, param4: JArray<UInt16>, param5: JArray<Int32>, param6: Float32, param7: JArray<Float32>, param8: JArray<Float32>, param9: Int8) {
        super(param9 + param9, param0, param1 + param1, param8, param3, param2, param4, param5, param7, param6 + param6)
    }
}
