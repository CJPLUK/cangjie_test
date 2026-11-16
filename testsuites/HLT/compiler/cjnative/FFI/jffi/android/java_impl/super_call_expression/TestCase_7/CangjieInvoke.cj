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

func globalFunction2(p: JArray<Float32>): Int16 {
    1i16
}

func globalFunction3(p: JArray<Float32>): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction4(p: Int8): JString {
    JString("hello")
}

func globalFunction5(p: JArray<Float32>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

func globalFunction6(p: Float32): Int32 {
    1i32
}

func globalFunction7(p: JArray<Int8>): JArray<Int8> {
    JArray<Int8>(114514i32)
}

func globalFunction8(p: JArray<Int32>): Int16 {
    1i16
}

func globalFunction9(p: JArray<UInt16>): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction10(p: JArray<UInt16>): JArray<Int32> {
    JArray<Int32>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JArray<Float32>, param1: Int32, param2: JArray<Int8>, param3: JArray<UInt16>,
        param4: JArray<UInt16>, param5: JArray<Int32>, param6: Float32, param7: JArray<Float32>,
        param8: JArray<Float32>, param9: Int8) {
        super(globalFunction1(param1), globalFunction2(param7), globalFunction3(param8), globalFunction4(param9),
            globalFunction5(param0), globalFunction6(param6), globalFunction7(param2), globalFunction8(param5),
            globalFunction9(param3), globalFunction10(param4))
    }
}
