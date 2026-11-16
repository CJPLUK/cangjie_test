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
// (Android) EXEC: %java %java_mirror_gen com.I
// (Android) EXEC: %java %java_mirror_gen com.Arg
// (Android) EXEC: %java %java_mirror_gen com.MI
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: MI {
    public init() {
        Logger.println("static: ${MI.staticMethod()}") // prints "static: 1"
        let x = MI().foo().getOrThrow() // prints "java: Hello from MI! [foo(): I]"
        Logger.println("I.staticMethod(): ${I.staticMethod()}"); // prints "I.staticMethod(): 1"
        Logger.println("x is I: ${x is I}"); // prints "x is I: true"
        Logger.println((x.foo(x))); // prints "java: Hello from MI! [foo(I): long]\n1"
        Arg().g(x) // prints "java: Hello from Arg! [g(I): long]"
        Logger.println("Hello from cj!")
    }
}
