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

import java.lang.JObject

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        Logger.println("in CangjieInvoke Init")
        // check I1
        Logger.println("I1.goo1 + goo2 : ${I1.goo1() + I1.goo2()}")

        // check abstract class C1
        Logger.println("C1.goo1 + goo2 : ${C1.goo1() + C1.goo2()}")

        // check class JavaClass
        var javaClass = JavaClass()
        Logger.println("JavaClass goo1: ${JavaClass.goo1()}")
        Logger.println("JavaClass goo2: ${JavaClass.goo2()}")
        Logger.println("javaClass foo1: ${javaClass.foo1()}")
        Logger.println("javaClass foo2: ${javaClass.foo2()}")
    }
}
