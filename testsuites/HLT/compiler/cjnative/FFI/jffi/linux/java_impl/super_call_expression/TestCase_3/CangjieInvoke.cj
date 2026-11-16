/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<Float32>): JArray<Int8> {
    JArray<Int8>(114514i32)
}

func globalFunction2(p: Int64): Float64 {
    114.514000f64
}

func globalFunction3(p: JArray<Int32>): Int32 {
    1i32
}

func globalFunction4(p: JArray<Float32>): Int16 {
    1i16
}

func globalFunction5(p: Int8): Int64 {
    1i64
}

func globalFunction6(p: JArray<Int8>): Int32 {
    1i32
}

func globalFunction7(p: JArray<Float32>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction8(p: Int32): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction9(p: JArray<Float64>): Float32 {
    114.514000f32
}

func globalFunction10(p: Float32): JArray<Int8> {
    JArray<Int8>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: Int8, param1: JArray<Int8>, param2: Int32, param3: JArray<Int32>, param4: JArray<Float32>,
        param5: JArray<Float64>, param6: JArray<Float32>, param7: Int64, param8: Float32, param9: JArray<Float32>) {
        super(globalFunction1(param9), globalFunction2(param7), globalFunction3(param3), globalFunction4(param6),
            globalFunction5(param0), globalFunction6(param1), globalFunction7(param4), globalFunction8(param2),
            globalFunction9(param5), globalFunction10(param8))
    }
}
