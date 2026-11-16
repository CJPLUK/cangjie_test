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
// (Android) ASSERT: scan original-1 instance aInt[9]: 18
// (Android) ASSERT: scan original-2 instance aInt[9]: 18
// (Android) ASSERT: scan changed-1 instance aInt[9]: 90
// (Android) ASSERT: scan original-1 static arrayInt[9]: 9
// (Android) ASSERT: scan original-2 static arrayInt[9]: 9
// (Android) ASSERT: scan changed-1 instance aInt[9]: 90

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let arr = JArray<Int32>(10)
        for (i in 0i32..10i32) {
            arr[i] = 2 * i
        }
        let javaclass = JavaClass(arr)
        println("original-1 instance aInt[9]: ${javaclass.aInt[9]}")
        println("original-2 instance aInt[9]: ${javaclass.getAInt()[9]}")
        let arr1 = JArray<Int32>(100)
        for (i in 0i32..30i32) {
            arr1[i] = 10 * i
        }
        javaclass.setAInt(arr1)
        println("changed-1 instance aInt[9]: ${javaclass.aInt[9]}")

        println("original-1 static arrayInt[9]: ${JavaClass.arrayInt[9]}")
        println("original-2 static arrayInt[9]: ${JavaClass.getArrayInt()[9]}")
        JavaClass.setArrayInt(arr1)
        println("changed-1 instance aInt[9]: ${JavaClass.getArrayInt()[9]}")
    }
}
