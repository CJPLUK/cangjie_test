/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: Int16): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction2(p: Int8): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction3(p: Int8): Int64 {
    1i64
}

func globalFunction4(p: Float64): Float64 {
    114.514000f64
}

func globalFunction5(p: JString): Int8 {
    1i8
}

func globalFunction6(p: JArray<Int64>): Int64 {
    1i64
}

func globalFunction7(p: Int64): Int16 {
    1i16
}

func globalFunction8(p: JArray<Int64>): Float32 {
    114.514000f32
}

func globalFunction9(p: Int8): Int8 {
    1i8
}

func globalFunction10(p: JArray<Int16>): UInt16 {
    1u16
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: Int8, param1: Int64, param2: JArray<Int16>, param3: JArray<Int64>, param4: JArray<Int64>,
        param5: Int8, param6: JString, param7: Int8, param8: Int16, param9: Float64) {
        super(globalFunction1(param8), globalFunction2(param0), globalFunction3(param7), globalFunction4(param9),
            globalFunction5(param6), globalFunction6(param3), globalFunction7(param1), globalFunction8(param4),
            globalFunction9(param5), globalFunction10(param2))
    }
}
