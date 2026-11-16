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
// (Android) ASSERT: scan java: JavaClass()
// (Android) ASSERT: scan java: 0th of long[] - 6
// (Android) ASSERT: scan java: 1th of long[] - 7
// (Android) ASSERT: scan java: 2th of long[] - 73
// (Android) ASSERT: scan java: 0th of JavaClass[] - 55312
// (Android) ASSERT: scan java: 1th of JavaClass[] - 55312
// (Android) ASSERT: scan java: 2th of JavaClass[] - 55312
// (Android) ASSERT: scan cangjie: CangjieInvoke()
// (Android) ASSERT: scan cangjie: 5th of F64 array - 1.000330
// (Android) ASSERT: scan cangjie: 2nd of F64 array - -9.554000
// (Android) ASSERT: scan cangjie: length of F64 array - 5
// (Android) ASSERT: scan cangjie: 2nd of JavaClass array - 55312
// (Android) ASSERT: scan cangjie: length of JavaClass array - 9
// (Android) ASSERT: scan cangjie: 1st of I64 array - 6
// (Android) ASSERT: scan cangjie: 2nd of I64 array - 7
// (Android) ASSERT: scan cangjie: 3rd of I64 array - 13
// (Android) ASSERT: scan cangjie: 1st of JavaClass array from Java - 55312
// (Android) ASSERT: scan cangjie: 2nd of JavaClass array from Java - 55312
// (Android) ASSERT: scan cangjie: 3rd of JavaClass array from Java - 55312
// (Android) ASSERT: scan cangjie: length of I64 array - 44

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JavaClass {
    public func foo(): JArray<Int64> {
        JArray<Int64>(44)
    }

    public init() {
        println("cangjie: CangjieInvoke()")

        let arr0 = JArray<Float64>(5)
        arr0[4] = 1.00033
        arr0[1] = -9.554
        println("cangjie: 5th of F64 array - " + arr0[4].toString())
        println("cangjie: 2nd of F64 array - " + arr0[1].toString())
        println("cangjie: length of F64 array - " + arr0.length.toString())

        let arr1 = JArray<JavaClass>(9)
        arr1[1] = JavaClass()
        println("cangjie: 2nd of JavaClass array - " + arr1[1].getInt().toString())
        println("cangjie: length of JavaClass array - " + arr1.length.toString())

        let arr2 = getArr()
        println("cangjie: 1st of I64 array - " + arr2[0].toString())
        println("cangjie: 2nd of I64 array - " + arr2[1].toString())
        println("cangjie: 3rd of I64 array - " + arr2[2].toString())
        arr2[2] = 73
        takeArr(arr2)

        let arr3 = getArr2()
        println("cangjie: 1st of JavaClass array from Java - " + arr3[0].getInt().toString())
        println("cangjie: 2nd of JavaClass array from Java - " + arr3[1].getInt().toString())
        println("cangjie: 3rd of JavaClass array from Java - " + arr3[2].getInt().toString())
        arr3[2] = JavaClass()
        takeArr2(arr3)

        let arr4 = this.foo()
        println("cangjie: length of I64 array - " + arr4.length.toString())
    }
}
