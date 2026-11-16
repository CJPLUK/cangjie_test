/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<UInt16>): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction2(p: JArray<UInt16>): JString {
    JString("hello")
}

func globalFunction3(p: JArray<Float64>): UInt16 {
    1u16
}

func globalFunction4(p: Int16): Float64 {
    114.514000f64
}

func globalFunction5(p: Float32): JArray<Int64> {
    JArray<Int64>(114514i32)
}

func globalFunction6(p: UInt16): JArray<Int64> {
    JArray<Int64>(114514i32)
}

func globalFunction7(p: JArray<Int64>): Float64 {
    114.514000f64
}

func globalFunction8(p: Float64): UInt16 {
    1u16
}

func globalFunction9(p: Int32): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction10(p: JArray<UInt16>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<UInt16>, param1: Float32, param2: UInt16, param3: JArray<Int64>, param4: Float64,
        param5: Int32, param6: JArray<UInt16>, param7: JArray<Float64>, param8: JArray<UInt16>, param9: Int16) {
        super(globalFunction1(param8), globalFunction2(param6), globalFunction3(param7), globalFunction4(param9),
            globalFunction5(param1), globalFunction6(param2), globalFunction7(param3), globalFunction8(param4),
            globalFunction9(param5), globalFunction10(param0))
    }
}
