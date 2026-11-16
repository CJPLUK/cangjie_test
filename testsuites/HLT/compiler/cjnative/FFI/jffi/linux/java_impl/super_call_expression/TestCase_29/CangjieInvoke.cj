/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<Float64>): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction2(p: JArray<Int16>): Int32 {
    1i32
}

func globalFunction3(p: JArray<Int32>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction4(p: UInt16): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction5(p: JString): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction6(p: JArray<Int16>): JArray<Int8> {
    JArray<Int8>(114514i32)
}

func globalFunction7(p: JArray<Int64>): Int16 {
    1i16
}

func globalFunction8(p: Float32): UInt16 {
    1u16
}

func globalFunction9(p: JArray<Int8>): Float32 {
    114.514000f32
}

func globalFunction10(p: JArray<Float32>): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: UInt16, param1: JArray<Int64>, param2: JArray<Float64>, param3: Float32, param4: JArray<Int16>,
        param5: JArray<Int16>, param6: JArray<Float32>, param7: JArray<Int8>, param8: JString, param9: JArray<Int32>) {
        super(globalFunction1(param2), globalFunction2(param5), globalFunction3(param9), globalFunction4(param0),
            globalFunction5(param8), globalFunction6(param4), globalFunction7(param1), globalFunction8(param3),
            globalFunction9(param7), globalFunction10(param6))
    }
}
