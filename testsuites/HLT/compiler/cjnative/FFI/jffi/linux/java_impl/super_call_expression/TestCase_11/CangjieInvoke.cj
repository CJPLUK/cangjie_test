/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package UNNAMED

import java.lang.*

func globalFunction1(p: JArray<Int16>): JArray<Float32> {
    JArray<Float32>(114514i32)
}

func globalFunction2(p: UInt16): Int16 {
    1i16
}

func globalFunction3(p: Int8): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

func globalFunction4(p: JArray<Int8>): Int32 {
    1i32
}

func globalFunction5(p: JString): JString {
    JString("hello")
}

func globalFunction6(p: JArray<Int16>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction7(p: JArray<UInt16>): Int64 {
    1i64
}

func globalFunction8(p: Int64): UInt16 {
    1u16
}

func globalFunction9(p: JArray<Int8>): JArray<Int16> {
    JArray<Int16>(114514i32)
}

func globalFunction10(p: Int64): JArray<UInt16> {
    JArray<UInt16>(114514i32)
}

@Java
public class ChildClass <: ParentClass {
    public init(param0: JString, param1: JArray<Int16>, param2: JArray<Int16>, param3: Int64, param4: Int8,
        param5: JArray<Int8>, param6: JArray<Int8>, param7: JArray<UInt16>, param8: Int64, param9: UInt16) {
        super(globalFunction1(param1), globalFunction2(param9), globalFunction3(param4), globalFunction4(param5),
            globalFunction5(param0), globalFunction6(param2), globalFunction7(param7), globalFunction8(param3),
            globalFunction9(param6), globalFunction10(param8))
    }
}
