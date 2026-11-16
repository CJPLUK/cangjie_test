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
// (Android) EXEC: cat UNNAMED/src/*.cj
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan in JavaClass Init
// (Android) ASSERT: scan-2 in JavaClass loaction_param:
// (Android) ASSERT: scan in JavaClass loaction_param:hello, 仓颉
// (Android) ASSERT: scan in JavaClass loaction_return

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("in CangjieInvoke Init")
        let javaClass = JavaClass()
        javaClass.loaction_param(JString())
        javaClass.loaction_param(JString("hello, 仓颉"))

        println("JString.toString: ${javaClass.loaction_return()?.toString()}")
        println("JavaClass name: ${javaClass.toString()}")
        println("end CangjieInvoke Init")
    }
}
