/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (Android) DEPENDENCE: com MainInstrumentedTest.java 
// (Android) EXEC: %javac com/*.java %java_interop_util/Logger.java
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass()
        Logger.println(
            "instance member of JavaClass are: ${javaclass.aBoolean.getOrThrow()[0]}, ${javaclass.aByte.getOrThrow()[0]}, ${javaclass.aShort.getOrThrow()[0]}, ${javaclass.aChar.getOrThrow()[0]}, ${javaclass.aInt.getOrThrow()[0]}, ${javaclass.aLong.getOrThrow()[0]}, ${javaclass.aFloat.getOrThrow()[0]}, ${javaclass.aDouble.getOrThrow()[0]}"
        )
        Logger.println(
            "instance member of JavaClass are: ${JavaClass.arrBoolean.getOrThrow()[0]}, ${JavaClass.arrByte.getOrThrow()[0]}, ${JavaClass.arrShort.getOrThrow()[0]}, ${JavaClass.arrChar.getOrThrow()[0]}, ${JavaClass.arrInt.getOrThrow()[0]}, ${JavaClass.arrLong.getOrThrow()[0]}, ${JavaClass.arrFloat.getOrThrow()[0]}, ${JavaClass.arrDouble.getOrThrow()[0]}"
        )
    }
}
