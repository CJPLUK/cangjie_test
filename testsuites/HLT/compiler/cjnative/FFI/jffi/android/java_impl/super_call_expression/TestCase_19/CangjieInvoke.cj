/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<UInt16>): Float32 {
    114.514000f32
}

func globalFunction2(p: Float64): Int16 {
    1i16
}

func globalFunction3(p: JString): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction4(p: Int8): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction5(p: Float64): Float64 {
    114.514000f64
}

func globalFunction6(p: JArray<Float32>): Float32 {
    114.514000f32
}

func globalFunction7(p: Float64): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction8(p: JArray<Int32>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction9(p: Int64): Float64 {
    114.514000f64
}

func globalFunction10(p: JArray<Int8>): JArray<Int8> {
    JArray<Int8>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: Int64, param1: JArray<UInt16>, param2: JArray<Int8>, param3: Float64, param4: Float64,
        param5: JString, param6: JArray<Int32>, param7: JArray<Float32>, param8: Int8, param9: Float64) {
        super(globalFunction1(param1), globalFunction2(param9), globalFunction3(param5), globalFunction4(param8),
            globalFunction5(param3), globalFunction6(param7), globalFunction7(param4), globalFunction8(param6),
            globalFunction9(param0), globalFunction10(param2))
    }
}
