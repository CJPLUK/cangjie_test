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
// (Android) EXEC: %java %java_mirror_gen com.C1
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.JObject

@Java
public class CangjieInvoke <: JObject {
    public init() {
        Logger.println("in CangjieInvoke Init")
        var javaClass = JavaClass()
        var v1 = javaClass.goo()
        Logger.println("JavaClass goo: ${v1}")
        var v2 = JavaClass.bar()
        Logger.println("JavaClass bar: ${v2}")
        var _v2 = C1.bar()
        Logger.println("C1 bar: ${_v2}")

        var v3 = javaClass.newoo()
        Logger.println("JavaClass newoo: ${v3}")
    }
}
