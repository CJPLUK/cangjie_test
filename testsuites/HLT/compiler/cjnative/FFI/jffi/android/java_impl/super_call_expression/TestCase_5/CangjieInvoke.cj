/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: UInt16): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction2(p: JString): Float32 {
    114.514000f32
}

func globalFunction3(p: Int8): Int8 {
    1i8
}

func globalFunction4(p: Int16): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction5(p: Int32): UInt16 {
    1u16
}

func globalFunction6(p: JArray<Float32>): Int8 {
    1i8
}

func globalFunction7(p: JArray<Float64>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction8(p: JArray<Int64>): Int16 {
    1i16
}

func globalFunction9(p: JString): Int16 {
    1i16
}

func globalFunction10(p: JArray<Int8>): JArray<Int8> {
    JArray<Int8>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<Float32>, param1: JArray<Float64>, param2: JArray<Int64>, param3: JString,
        param4: UInt16, param5: JArray<Int8>, param6: JString, param7: Int16, param8: Int32, param9: Int8) {
        super(globalFunction1(param4), globalFunction2(param3), globalFunction3(param9), globalFunction4(param7),
            globalFunction5(param8), globalFunction6(param0), globalFunction7(param1), globalFunction8(param2),
            globalFunction9(param6), globalFunction10(param5))
    }
}
