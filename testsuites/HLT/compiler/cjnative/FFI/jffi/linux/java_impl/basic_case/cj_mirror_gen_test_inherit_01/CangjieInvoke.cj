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
// (Android) EXEC: %java %java_mirror_gen com.Inherit
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. com.java.app.Main 2>&1 | compare %f
// (Android) ASSERT: scan run java
// (Android) ASSERT: scan Java-Inherit-foo
// (Android) ASSERT: scan Java-Inherit-goo

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let class_01 = Inherit(1)
        class_01.aByte
        class_01.foo()
        Inherit.goo()
    }
}
