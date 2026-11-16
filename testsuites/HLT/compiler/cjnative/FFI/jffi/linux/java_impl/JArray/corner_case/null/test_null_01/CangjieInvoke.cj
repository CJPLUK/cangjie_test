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
// (Android) ASSERT: scan javaclass.aInt[0]: 4321
// (Android) ASSERT: scan JavaClass.arrayInt[0]: 4321
// (Android) ASSERT: scan javaclass.aInt[0]: 54321
// (Android) ASSERT: scan JavaClass.arrayInt[0]: 54321
// (Android) ASSERT: scan javaclass.aString[1]: hello, 仓颉
// (Android) ASSERT: scan-not hello, world

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass(JArray<Int32>(0))
        let arr = JArray<Int32>(1)
        arr[0] = 4321
        javaclass.aInt = arr
        println("javaclass.aInt[0]: ${javaclass.aInt[0]}")
        JavaClass.setArrayInt(arr)
        println("JavaClass.arrayInt[0]: ${JavaClass.arrayInt[0]}")

        arr[0] = 54321
        println("javaclass.aInt[0]: ${javaclass.aInt[0]}")
        println("JavaClass.arrayInt[0]: ${JavaClass.arrayInt[0]}")

        var jstr = JString("hello, 仓颉")
        javaclass.aString[1] = jstr
        println("javaclass.aString[1]: ${javaclass.aString[1].toString()}")
        jstr = JString("hello, world")
        println("javaclass.aString[1]: ${javaclass.aString[1].toString()}")
    }
}
