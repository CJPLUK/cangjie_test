/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java com
// (Android) EXEC: %javac com/*.java
// (Android) EXEC: %java %java_mirror_gen com.I
// (Android) EXEC: %java %java_mirror_gen com.Arg
// (Android) EXEC: %java %java_mirror_gen com.MI
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan java: Hello from MI! [foo(): I]
// (Android) ASSERT: scan java: Hello from MI! [foo(I): long]
// (Android) ASSERT: scan java: Hello from Arg! [g(I): long]
// (Android) ASSERT: scan static: 1
// (Android) ASSERT: scan I.staticMethod(): 1
// (Android) ASSERT: scan x is I: true
// (Android) ASSERT: scan Hello from cj!

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: MI {
    public init() {
        println("static: ${MI.staticMethod()}") // prints "static: 1"
        let x = MI().foo().getOrThrow() // prints "java: Hello from MI! [foo(): I]"
        println("I.staticMethod(): ${I.staticMethod()}"); // prints "I.staticMethod(): 1"
        println("x is I: ${x is I}"); // prints "x is I: true"
        println(x.foo(x)); // prints "java: Hello from MI! [foo(I): long]\n1"
        Arg().g(x) // prints "java: Hello from Arg! [g(I): long]"
        println("Hello from cj!")
    }
}
