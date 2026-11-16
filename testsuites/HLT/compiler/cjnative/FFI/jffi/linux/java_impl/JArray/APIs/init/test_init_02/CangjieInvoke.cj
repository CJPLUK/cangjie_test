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

// 超大数组，大小为 Int32.Max-2
package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let javaclass = JavaClass()
        println("orginal-1 size aInt: ${javaclass.aInt.length}")
        println("orginal-1 size arrLong: ${JavaClass.arrLong.length}")

        println("changed-1 value arrLong: ${JavaClass.arrLong[0]}, ${JavaClass.arrLong[2147483645]}")
        var arr = JArray<Int32>(2147483645)
        arr[0] = 0
        arr[2147483645] = 2147483645
        javaclass.aInt = arr
        JavaClass.arrLong = JArray<Int64>(0)

        println("changed-1 size aInt: ${javaclass.aInt.length}")
        println("changed-1 value aInt: ${javaclass.aInt[0]}, ${javaclass.aInt[2147483645]}")
        println("changed-2 size arrLong: ${JavaClass.arrLong.length}")
    }
}
