/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java com UNNAMED
// (Android) EXEC: %javac com/*.java
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. com.java.app.Main 2>&1 | compare %f
// (Android) ASSERT: scan run java
// (Android) ASSERT: scan this.aInt[0].length = 10
// (Android) ASSERT: scan this.aInt[0][9] = 9

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        let arr = JArray<Int32>(10)
        for (i in 0i32..10i32) {
            arr[i] = i
        }
        this.aInt[0] = arr
        println("this.aInt[0].length = ${this.aInt[0].length}")
        println("this.aInt[0][9] = ${this.aInt[0][9]}")
    }
}
