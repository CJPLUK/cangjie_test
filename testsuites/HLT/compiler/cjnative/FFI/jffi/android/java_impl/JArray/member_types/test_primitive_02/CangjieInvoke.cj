/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (Android) DEPENDENCE: com MainInstrumentedTest.java 
// (Android) EXEC: %javac com/*.java %java_interop_util/Logger.java
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        let arr_Bool: JArray<Bool> = JArray<Bool>(1)
        arr_Bool[0] = true
        let arr_Int8: JArray<Int8> = JArray<Int8>(10)
        arr_Int8[0] = 127
        let arr_Int16: JArray<Int16> = JArray<Int16>(2)
        arr_Int16[0] = 32767
        let arr_UInt16: JArray<UInt16> = JArray<UInt16>(1)
        arr_UInt16[0] = 100
        let arr_Int32: JArray<Int32> = JArray<Int32>(1)
        arr_Int32[0] = 2147483647
        let arr_Int64: JArray<Int64> = JArray<Int64>(1)
        arr_Int64[0] = 9223372036854775807
        let arr_Float32: JArray<Float32> = JArray<Float32>(1)
        arr_Float32[0] = 3.14159265f32
        let arr_Float64: JArray<Float64> = JArray<Float64>(1)
        arr_Float64[0] = 3.14159265f64

        Logger.println(
            "JArray in Cangjie are: ${arr_Bool[0]}, ${arr_Int8[0]}, ${arr_Int16[0]}, ${arr_UInt16[0]}, ${arr_Int32[0]}, ${arr_Int64[0]}, ${arr_Float32[0]}, ${arr_Float64[0]}"
        )
    }
}
