/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: Int64): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction2(p: Int64): Float32 {
    114.514000f32
}

func globalFunction3(p: JArray<Int8>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction4(p: Float64): JArray<Int64> {
    JArray<Int64>(114514i32)
}

func globalFunction5(p: JArray<Float64>): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction6(p: Int8): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction7(p: JArray<Float32>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction8(p: JArray<Int8>): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction9(p: JArray<UInt16>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction10(p: JArray<Int8>): Float64 {
    114.514000f64
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: Int8, param1: JArray<Int8>, param2: JArray<Float64>, param3: JArray<UInt16>,
        param4: JArray<Int8>, param5: Float64, param6: Int64, param7: JArray<Float32>, param8: Int64,
        param9: JArray<Int8>) {
        super(globalFunction1(param6), globalFunction2(param8), globalFunction3(param1), globalFunction4(param5),
            globalFunction5(param2), globalFunction6(param0), globalFunction7(param7), globalFunction8(param9),
            globalFunction9(param3), globalFunction10(param4))
    }
}
