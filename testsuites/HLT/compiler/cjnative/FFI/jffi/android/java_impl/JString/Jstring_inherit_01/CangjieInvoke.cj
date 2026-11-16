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
// (Android) EXEC: %java %java_mirror_gen com.JavaClass_Child
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.*

@Java
public class Cangjie_Invoke <: JavaClass_Child {
    public init() {
        Logger.println("in CangjieInvoke Init")
    }

    public override func foo(v1: Int32): Int32 {
        66666
    }

    public static redef func goo(v1: Int32, v2: Int32): Int32 {
        88888
    }
}

@Java
public class CangjieInvoke <: JObject {
    public init(v1: Int32) {
        let cjinvoke = Cangjie_Invoke()
        Logger.println(cjinvoke.foo(v1))
        Logger.println(cjinvoke.subfoo(v1))
        Logger.println(cjinvoke.value1)
        Logger.println(cjinvoke.subvalue1)
        Logger.println(Cangjie_Invoke.goo(v1, v1))
        Logger.println(Cangjie_Invoke.value2)
        Logger.println(Cangjie_Invoke.subvalue2)

        let javainvoke = JavaClass_Child()
        Logger.println(javainvoke.foo(v1))
        Logger.println(javainvoke.subfoo(v1))
        Logger.println(javainvoke.value1)
        Logger.println(javainvoke.subvalue1)
        Logger.println(JavaClass_Child.goo(v1, v1))
        Logger.println(JavaClass_Child.value2)
        Logger.println(JavaClass_Child.subvalue2)
    }
}
