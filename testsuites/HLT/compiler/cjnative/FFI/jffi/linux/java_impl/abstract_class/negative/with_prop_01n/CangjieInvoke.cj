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
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan in C1 init12
// (Android) ASSERT: scan in JavaClass Init12
// (Android) ASSERT: scan JavaClass newoo: 10001

package UNNAMED

import java.lang.JObject

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("in CangjieInvoke Init")
        var javaClass = JavaClass()
        var v1 = javaClass.goo()
        println("JavaClass goo: ${v1}")
        var v2 = JavaClass.bar()
        println("JavaClass bar: ${v2}")
        var _v2 = C1.bar()
        println("C1 bar: ${_v2}")

        var v3 = javaClass.newoo()
        println("JavaClass newoo: ${v3}")
    }
}
