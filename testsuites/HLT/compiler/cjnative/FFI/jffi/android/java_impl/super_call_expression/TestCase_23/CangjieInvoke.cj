/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: Int8): JString {
    JString("hello")
}

func globalFunction2(p: Int32): JString {
    JString("hello")
}

func globalFunction3(p: JArray<UInt16>): Int32 {
    1i32
}

func globalFunction4(p: Float64): Int32 {
    1i32
}

func globalFunction5(p: JArray<Float32>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction6(p: JArray<Float64>): JArray<Float64> {
    JArray<Float64>(114514i32)
}

func globalFunction7(p: Int16): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction8(p: JArray<Int8>): Int8 {
    1i8
}

func globalFunction9(p: JArray<Int32>): JString {
    JString("hello")
}

func globalFunction10(p: Float32): JArray<Float32> {
    JArray<Float32>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: Float32, param1: Float64, param2: Int16, param3: JArray<Float32>, param4: JArray<Int32>,
        param5: JArray<UInt16>, param6: JArray<Int8>, param7: Int32, param8: Int8, param9: JArray<Float64>) {
        super(globalFunction1(param8), globalFunction2(param7), globalFunction3(param5), globalFunction4(param1),
            globalFunction5(param3), globalFunction6(param9), globalFunction7(param2), globalFunction8(param6),
            globalFunction9(param4), globalFunction10(param0))
    }
}
