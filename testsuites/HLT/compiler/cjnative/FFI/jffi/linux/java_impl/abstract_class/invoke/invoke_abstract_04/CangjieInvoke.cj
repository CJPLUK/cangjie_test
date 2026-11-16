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
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java TestClass.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan in JavaClass bar
// (Android) ASSERT: scan in CangjieInvoke Init
// (Android) ASSERT: scan in TestClass Init
// (Android) ASSERT: scan in TestClass goo
// (Android) ASSERT: scan testclass.goo(): 88
// (Android) ASSERT: scan in CangjieInvoke newoo
// (Android) ASSERT: scan testclass.newoo(): 12345
// (Android) ASSERT: scan in TestClass bar
// (Android) ASSERT: scan TestClass.bar(): 54321
// (Android) ASSERT: scan JavaClass.bar(): 1

package UNNAMED

import java.lang.*

@Java
private class TestClass <: JavaClass {
    public init() {
        super()
        println("in TestClass Init")
    }

    public override func goo() {
        println("in TestClass goo")
        return 88i32
    }

    public static redef func bar() {
        println("in TestClass bar")
        return 54321i32
    }

    public func newoo(): Int32 {
        println("in CangjieInvoke newoo")
        return 12345
    }
}

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("in CangjieInvoke Init")
        var testclass = TestClass()
        println("testclass.goo(): ${testclass.goo()}")
        println("testclass.newoo(): ${testclass.newoo()}")
        println("TestClass.bar(): ${TestClass.bar()}")
        println("JavaClass.bar(): ${JavaClass.bar()}")
    }
}
