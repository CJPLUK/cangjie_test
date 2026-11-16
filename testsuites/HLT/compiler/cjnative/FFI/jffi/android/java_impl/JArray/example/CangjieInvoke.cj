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
    public func foo(): JArray<Int64> {
        JArray<Int64>(44)
    }

    public init() {
        Logger.println("cangjie: CangjieInvoke()")

        let arr0 = JArray<Float64>(5)
        arr0[4] = 1.00033
        arr0[1] = -9.554
        Logger.println("cangjie: 5th of F64 array - " + arr0[4].toString())
        Logger.println("cangjie: 2nd of F64 array - " + arr0[1].toString())
        Logger.println("cangjie: length of F64 array - " + arr0.length.toString())

        let arr1 = JArray<JavaClass>(9)
        arr1[1] = JavaClass()
        Logger.println("cangjie: 2nd of JavaClass array - " + arr1[1].getInt().toString())
        Logger.println("cangjie: length of JavaClass array - " + arr1.length.toString())

        let arr2 = getArr()
        Logger.println("cangjie: 1st of I64 array - " + arr2.getOrThrow()[0].toString())
        Logger.println("cangjie: 2nd of I64 array - " + arr2.getOrThrow()[1].toString())
        Logger.println("cangjie: 3rd of I64 array - " + arr2.getOrThrow()[2].toString())
        arr2.getOrThrow()[2] = 73
        takeArr(arr2)
        let arr3 = getArr2()
        Logger.println(
            "cangjie: 1st of JavaClass array from Java - " + arr3.getOrThrow()[0].getOrThrow().getInt().toString())
        Logger.println(
            "cangjie: 2nd of JavaClass array from Java - " + arr3.getOrThrow()[1].getOrThrow().getInt().toString())
        Logger.println(
            "cangjie: 3rd of JavaClass array from Java - " + arr3.getOrThrow()[2].getOrThrow().getInt().toString())
        arr3.getOrThrow()[2] = JavaClass()
        takeArr2(arr3)

        let arr4 = this.foo()
        Logger.println("cangjie: length of I64 array - " + arr4.length.toString())
    }
}
