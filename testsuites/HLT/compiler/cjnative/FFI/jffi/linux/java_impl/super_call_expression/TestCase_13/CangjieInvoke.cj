/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<Int16>): Int8 {
    1i8
}

func globalFunction2(p: JArray<Float32>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction3(p: JArray<Int8>): Int16 {
    1i16
}

func globalFunction4(p: Int64): Int16 {
    1i16
}

func globalFunction5(p: Float32): Int8 {
    1i8
}

func globalFunction6(p: JString): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction7(p: Int8): Int8 {
    1i8
}

func globalFunction8(p: Int64): JString {
    JString("hello")
}

func globalFunction9(p: JArray<Float64>): UInt16 {
    1u16
}

func globalFunction10(p: UInt16): UInt16 {
    1u16
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<Float64>, param1: Int64, param2: Float32, param3: JArray<Int16>, param4: Int64,
        param5: Int8, param6: JArray<Float32>, param7: UInt16, param8: JString, param9: JArray<Int8>) {
        super(globalFunction1(param3), globalFunction2(param6), globalFunction3(param9), globalFunction4(param4),
            globalFunction5(param2), globalFunction6(param8), globalFunction7(param5), globalFunction8(param1),
            globalFunction9(param0), globalFunction10(param7))
    }
}
