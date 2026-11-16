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
// (Android) ASSERT: scan-3 in C1 init
// (Android) ASSERT: scan-3 in JavaClass Init
// (Android) ASSERT: scan in CangjieInvoke Init
// (Android) ASSERT: scan in JavaClass new newoo

package UNNAMED

import java.lang.JObject

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        print("in CangjieInvoke Init\n", flush: true)
        var javaClass = JavaClass()
        javaClass.newoo(javaClass)
    }
}
