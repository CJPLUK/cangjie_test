/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<Float64>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction2(p: JArray<Int64>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction3(p: JArray<Int16>): Int16 {
    1i16
}

func globalFunction4(p: Int32): Int8 {
    1i8
}

func globalFunction5(p: Int8): Int8 {
    1i8
}

func globalFunction6(p: JArray<Int16>): Int16 {
    1i16
}

func globalFunction7(p: JArray<Int16>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction8(p: UInt16): Float64 {
    114.514000f64
}

func globalFunction9(p: Float64): JString {
    JString("hello")
}

func globalFunction10(p: JArray<Int32>): Int16 {
    1i16
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<Int64>, param1: JArray<Int32>, param2: JArray<Int16>, param3: Int8,
        param4: JArray<Int16>, param5: JArray<Int16>, param6: UInt16, param7: Float64, param8: JArray<Float64>,
        param9: Int32) {
        super(globalFunction1(param8), globalFunction2(param0), globalFunction3(param5), globalFunction4(param9),
            globalFunction5(param3), globalFunction6(param4), globalFunction7(param2), globalFunction8(param6),
            globalFunction9(param7), globalFunction10(param1))
    }
}
