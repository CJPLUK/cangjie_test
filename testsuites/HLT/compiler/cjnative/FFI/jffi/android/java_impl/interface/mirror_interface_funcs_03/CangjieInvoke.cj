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
// (Android) EXEC: %java %java_mirror_gen com.I1
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        Logger.println("in CangjieInvoke Init")
    }

    public func test() {
        Logger.println("in CangjieInvoke Func")
        var javaClass = JavaClass()
        var v1 = javaClass.goo(javaClass.foo())
        Logger.println("JavaClass inherit goo: ${v1}")
        var _v2 = I1.bar()
        Logger.println("I1 bar: ${_v2}")
        var v2 = JavaClass.bar()
        Logger.println("JavaClass inherit bar: ${v2}")
        var v3 = javaClass.goo()
        Logger.println("JavaClass new goo: ${v3}")
        var v4 = JavaClass.bar(1234)
        Logger.println("JavaClass new bar: ${v4}")
    }
}
