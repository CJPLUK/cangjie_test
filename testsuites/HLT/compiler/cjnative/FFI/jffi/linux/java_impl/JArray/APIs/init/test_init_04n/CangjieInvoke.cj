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
// (Android) ASSERT: scan orginal-1 size aInt: 100001
// (Android) ASSERT: scan orginal-1 size arrLong: 100001
// (Android) ASSERT: scan changed-1 value arrLong: 0, 100000
// (Android) ASSERT: scan arr[10000]: -2147483648

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass()
        println("orginal-1 size aInt: ${javaclass.aInt.length}")
        println("orginal-1 size arrLong: ${JavaClass.arrLong.length}")

        println("changed-1 value arrLong: ${JavaClass.arrLong[0]}, ${JavaClass.arrLong[100000]}")
        var arr = JArray<Int32>(10001)
        arr[0] = 0
        arr[10000] = -2147483648
        println("arr[10000]: ${arr[10000]}")
    }
}
