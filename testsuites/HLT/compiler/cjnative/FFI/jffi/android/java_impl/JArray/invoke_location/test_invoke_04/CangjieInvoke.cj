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
    }

    public init(arr0: JArray<Int32>, arr1!: JArray<Bool>) {
        Logger.println("arr0.size = ${arr0.length}, arr1.size = ${arr1.length}")
        Logger.println("arr0[0] = ${arr0[0]}, arr1[0] = ${arr1[0]}")
    }

    public func foo(arr0: JArray<Int64>, arr1!: JArray<JString>): JString {
        var str: String = ""
        for (i in 0i32..arr0.length) {
            str += arr0[i].toString()
        }
        for (i in 0i32..arr1.length) {
            str += arr1[i].toString()
        }
        return JString(str)
    }

    public func goo(): JArray<JString> {
        let array_str = JArray<JString>(2)
        array_str[0] = JString("hello, ")
        array_str[1] = JString("仓颉!")
        let arr = JArray<JString>(1)
        arr[0] = JString(array_str[0].toString() + array_str[1].toString())
        return arr
    }

    public static func hoo(arr0: JArray<Int32>): JArray<Int64> {
        let arr = JArray<Int64>(arr0.length)
        for (i in 0i32..arr0.length) {
            arr[i] = Int64(i)
        }
        return arr
    }
}
