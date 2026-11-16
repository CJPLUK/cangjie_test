/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JString): Int16 {
    1i16
}

func globalFunction2(p: JArray<Int64>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction3(p: JArray<Float64>): Int16 {
    1i16
}

func globalFunction4(p: JArray<Float64>): Float32 {
    114.514000f32
}

func globalFunction5(p: Int64): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction6(p: UInt16): JString {
    JString("hello")
}

func globalFunction7(p: Float64): Int8 {
    1i8
}

func globalFunction8(p: UInt16): Float32 {
    114.514000f32
}

func globalFunction9(p: JArray<Int32>): Float64 {
    114.514000f64
}

func globalFunction10(p: JArray<Int16>): JArray<Int64> {
    JArray<Int64>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: Int64, param1: JArray<Float64>, param2: UInt16, param3: UInt16, param4: JArray<Int32>,
        param5: JArray<Int16>, param6: JString, param7: JArray<Float64>, param8: JArray<Int64>, param9: Float64) {
        super(globalFunction1(param6), globalFunction2(param8), globalFunction3(param7), globalFunction4(param1),
            globalFunction5(param0), globalFunction6(param2), globalFunction7(param9), globalFunction8(param3),
            globalFunction9(param4), globalFunction10(param5))
    }
}
