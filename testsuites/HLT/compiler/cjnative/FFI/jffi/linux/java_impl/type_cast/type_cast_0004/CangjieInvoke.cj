/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java com
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java
// (Android) ASSERT: scan run cj
// (Android) ASSERT: scan JavaSuperClass
// (Android) ASSERT: scan JavaClass
// (Android) ASSERT: scan is true

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("run cj")
        let a = JavaClass() as JavaSuperClass
        println("is ${a.getOrThrow().b}")
    }
}
