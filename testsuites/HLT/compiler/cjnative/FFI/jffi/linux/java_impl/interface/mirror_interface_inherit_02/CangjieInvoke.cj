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
// (Android) EXEC: %java %java_mirror_gen com.JavaClass_Father
// (Android) EXEC: %java %java_mirror_gen com.I1
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan-3 in JavaClass Init
// (Android) ASSERT: scan-5 in JavaClass_Father Init
// (Android) ASSERT: scan in JavaClass_Father foo
// (Android) ASSERT: scan in JavaClass_Father goo
// (Android) ASSERT: scan-2 in I1 bar
// (Android) ASSERT: scan in JavaClass_Father bar
// (Android) ASSERT: scan-2 in JavaClass_Father new goo
// (Android) ASSERT: scan-2 in JavaClass_Father new bar
// (Android) ASSERT: scan in JavaClass foo
// (Android) ASSERT: scan in JavaClass goo
// (Android) ASSERT: scan in JavaClass bar
// (Android) ASSERT: scan-2 in CangjieInvoke Init
// (Android) ASSERT: scan JavaClass_Father inherit goo: 10
// (Android) ASSERT: scan-2 I1 bar: 1
// (Android) ASSERT: scan JavaClass_Father inherit bar: 100
// (Android) ASSERT: scan JavaClass_Father new goo: 1000
// (Android) ASSERT: scan JavaClass_Father new bar: -1
// (Android) ASSERT: scan JavaClass inherit goo: 20
// (Android) ASSERT: scan JavaClass inherit bar: 200
// (Android) ASSERT: scan JavaClass new goo: 1000
// (Android) ASSERT: scan JavaClass new bar: 111

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
    }

    public func test1(a: Int32) {
        println("in CangjieInvoke Init")
        var javaClass = JavaClass_Father()
        var v1 = javaClass.goo(javaClass.foo())
        println("JavaClass_Father inherit goo: ${v1}")
        var _v2 = I1.bar()
        println("I1 bar: ${_v2}")
        var v2 = JavaClass_Father.bar()
        println("JavaClass_Father inherit bar: ${v2}")
        var v3 = javaClass.goo()
        println("JavaClass_Father new goo: ${v3}")
        var v4 = JavaClass_Father.bar(a)
        println("JavaClass_Father new bar: ${v4}")
    }

    public func test2(a: Int32) {
        println("in CangjieInvoke Init")
        var javaClass = JavaClass()
        var v1 = javaClass.goo(javaClass.foo())
        println("JavaClass inherit goo: ${v1}")
        var _v2 = I1.bar()
        println("I1 bar: ${_v2}")
        var v2 = JavaClass.bar()
        println("JavaClass inherit bar: ${v2}")
        var v3 = javaClass.goo()
        println("JavaClass new goo: ${v3}")
        var v4 = JavaClass.bar(a)
        println("JavaClass new bar: ${v4}")
    }
}
