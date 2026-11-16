/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: Int32): Int32 {
    1i32
}

func globalFunction2(p: JArray<Int64>): JArray<Int8> {
    JArray<Int8>(114514i32)
}

func globalFunction3(p: JArray<Float32>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction4(p: JArray<UInt16>): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction5(p: Float64): UInt16 {
    1u16
}

func globalFunction6(p: JArray<UInt16>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction7(p: JArray<Int8>): Int32 {
    1i32
}

func globalFunction8(p: JArray<Float32>): Float64 {
    114.514000f64
}

func globalFunction9(p: JArray<UInt16>): Float32 {
    114.514000f32
}

func globalFunction10(p: JArray<Float64>): Int64 {
    1i64
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<Float64>, param1: Float64, param2: Int32, param3: JArray<UInt16>, param4: JArray<UInt16>,
        param5: JArray<Int64>, param6: JArray<UInt16>, param7: JArray<Int8>, param8: JArray<Float32>,
        param9: JArray<Float32>) {
        super(globalFunction1(param2), globalFunction2(param5), globalFunction3(param8), globalFunction4(param6),
            globalFunction5(param1), globalFunction6(param3), globalFunction7(param7), globalFunction8(param9),
            globalFunction9(param4), globalFunction10(param0))
    }
}
