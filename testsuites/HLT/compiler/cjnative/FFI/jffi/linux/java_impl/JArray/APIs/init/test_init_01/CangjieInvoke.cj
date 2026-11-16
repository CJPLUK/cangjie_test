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
// (Android) ASSERT: scan orginal-1 size aInt: 0
// (Android) ASSERT: scan orginal-1 size arrLong: 10
// (Android) ASSERT: scan changed-1 value arrLong: 666, 888
// (Android) ASSERT: scan changed-1 size aInt: 100
// (Android) ASSERT: scan changed-1 value aInt: 0, 99
// (Android) ASSERT: scan changed-2 size arrLong: 0

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass()
        println("orginal-1 size aInt: ${javaclass.aInt.length}")
        println("orginal-1 size arrLong: ${JavaClass.arrLong.length}")

        JavaClass.arrLong[0] = 666
        JavaClass.arrLong[9] = 888
        println("changed-1 value arrLong: ${JavaClass.arrLong[0]}, ${JavaClass.arrLong[9]}")
        var arr = JArray<Int32>(100)
        arr[0] = 0
        arr[99] = 99
        javaclass.aInt = arr
        JavaClass.arrLong = JArray<Int64>(0)

        println("changed-1 size aInt: ${javaclass.aInt.length}")
        println("changed-1 value aInt: ${javaclass.aInt[0]}, ${javaclass.aInt[99]}")
        println("changed-2 size arrLong: ${JavaClass.arrLong.length}")
    }
}
