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
// (Android) ASSERT: scan in JavaClass goo
// (Android) ASSERT: scan in JavaClass bar
// (Android) ASSERT: scan in CangjieInvoke Init
// (Android) ASSERT: scan this goo: 66
// (Android) ASSERT: scan JavaClass bar: 1

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        println("in CangjieInvoke Init")

        var v1 = this.goo() // error
        println("this goo: ${v1}")
        var v2 = JavaClass.bar()
        println("JavaClass bar: ${v2}")
    }

    public func newoo(): Int32 {
        println("in CangjieInvoke newoo")
        return 1234
    }
}
