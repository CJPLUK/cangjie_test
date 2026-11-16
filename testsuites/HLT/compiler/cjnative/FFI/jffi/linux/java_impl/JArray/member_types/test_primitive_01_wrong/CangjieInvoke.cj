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
// (Android) EXEC: cat UNNAMED/src/*.cj
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. com.java.app.Main 2>&1 | compare %f
// (Android) ASSERT: scan run java

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass()
        println(
            "instance member of JavaClass are: ${javaclass.aBoolean.getOrThrow()[0]}, ${javaclass.aByte.getOrThrow()[0]}, ${javaclass.aShort.getOrThrow()[0]}, ${javaclass.aChar.getOrThrow()[0]}, ${javaclass.aInt.getOrThrow()[0]}, ${javaclass.aLong.getOrThrow()[0]}, ${javaclass.aFloat.getOrThrow()[0]}, ${javaclass.aDouble.getOrThrow()[0]}"
        )
        println(
            "instance member of JavaClass are: ${JavaClass.arrBoolean.getOrThrow()[0]}, ${JavaClass.arrByte.getOrThrow()[0]}, ${JavaClass.arrShort.getOrThrow()[0]}, ${JavaClass.arrChar.getOrThrow()[0]}, ${JavaClass.arrInt.getOrThrow()[0]}, ${JavaClass.arrLong.getOrThrow()[0]}, ${JavaClass.arrFloat.getOrThrow()[0]}, ${JavaClass.arrDouble.getOrThrow()[0]}"
        )
    }
}
