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
        let javaclass = JavaClass(JArray<Int32>(0))
        let arr = JArray<Int32>(1)
        arr[0] = 4321
        javaclass.aInt = arr
        Logger.println("javaclass.aInt[0]: ${javaclass.aInt.getOrThrow()[0]}")
        JavaClass.setArrayInt(arr)
        Logger.println("JavaClass.arrayInt[0]: ${JavaClass.arrayInt.getOrThrow()[0]}")

        arr[0] = 54321
        Logger.println("javaclass.aInt[0]: ${javaclass.aInt.getOrThrow()[0]}")
        Logger.println("JavaClass.arrayInt[0]: ${JavaClass.arrayInt.getOrThrow()[0]}")

        var jstr = JString("hello, 仓颉")
        javaclass.aString.getOrThrow()[1] = jstr
        Logger.println("javaclass.aString[1]: ${javaclass.aString.getOrThrow()[1].getOrThrow().toString()}")
        jstr = JString("hello, world")
        Logger.println("javaclass.aString[1]: ${javaclass.aString.getOrThrow()[1].getOrThrow().toString()}")
    }
}
