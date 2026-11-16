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
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass()
        Logger.println("orginal-1 size aInt: ${javaclass.aInt.getOrThrow().length}")
        Logger.println("orginal-1 size arrLong: ${JavaClass.arrLong.getOrThrow().length}")

        Logger.println("changed-1 value arrLong: ${JavaClass.arrLong.getOrThrow()[0]}, ${JavaClass.arrLong.getOrThrow()[100000]}")
        var arr = JArray<Int32>(10001)
        arr[0] = 0
        arr[10000] = -2147483648
        Logger.println("arr[10000]: ${arr[10000]}")
    }
}
