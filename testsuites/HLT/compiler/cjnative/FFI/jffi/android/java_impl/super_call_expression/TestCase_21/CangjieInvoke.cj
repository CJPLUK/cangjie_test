/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: Float32): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction2(p: JArray<Int64>): Int16 {
    1i16
}

func globalFunction3(p: JArray<UInt16>): Int16 {
    1i16
}

func globalFunction4(p: JArray<Int64>): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction5(p: JArray<Float32>): Float64 {
    114.514000f64
}

func globalFunction6(p: JArray<Int16>): Float32 {
    114.514000f32
}

func globalFunction7(p: Float32): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction8(p: Int16): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction9(p: JArray<Int8>): JString {
    JString("hello")
}

func globalFunction10(p: JArray<UInt16>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<UInt16>, param1: JArray<Float32>, param2: Int16, param3: JArray<UInt16>,
        param4: JArray<Int16>, param5: JArray<Int64>, param6: JArray<Int8>, param7: JArray<Int64>, param8: Float32,
        param9: Float32) {
        super(globalFunction1(param8), globalFunction2(param7), globalFunction3(param0), globalFunction4(param5),
            globalFunction5(param1), globalFunction6(param4), globalFunction7(param9), globalFunction8(param2),
            globalFunction9(param6), globalFunction10(param3))
    }
}
