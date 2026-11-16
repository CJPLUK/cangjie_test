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
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC: cat UNNAMED/src/*.cj
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan I1.goo1: 1
// (Android) ASSERT: scan I2.goo2: 2
// (Android) ASSERT: scan C1.goo3 : 1000
// (Android) ASSERT: scan C1.goo1 : 1
// (Android) ASSERT: scan JavaClass goo1: 510
// (Android) ASSERT: scan JavaClass goo2: 520
// (Android) ASSERT: scan JavaClass goo3: 530
// (Android) ASSERT: scan javaClass foo1: 51
// (Android) ASSERT: scan javaClass foo2: 52
// (Android) ASSERT: scan javaClass foo3: 53
// (Android) ASSERT: scan javaClass foo4: 54
// (Android) ASSERT: scan CangjieInvoke foo1: 151
// (Android) ASSERT: scan CangjieInvoke foo2: 152
// (Android) ASSERT: scan CangjieInvoke foo3: 153
// (Android) ASSERT: scan CangjieInvoke foo4: 154
// (Android) ASSERT: scan CangjieInvoke goo1: -1
// (Android) ASSERT: scan CangjieInvoke goo2: -2
// (Android) ASSERT: scan CangjieInvoke goo3: -3

package UNNAMED

import java.lang.JObject

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        println("in CangjieInvoke Init")
        // check I1
        println("I1.goo1: ${I1.goo1()}")
        // check I2
        println("I2.goo2: ${I2.goo2()}")

        // check abstract class C1
        println("C1.goo3 : ${C1.goo3()}")
        println("C1.goo1 : ${C1.goo1()}")

        // check class JavaClass
        println("JavaClass goo1: ${JavaClass.goo1()}")
        println("JavaClass goo2: ${JavaClass.goo2()}")
        println("JavaClass goo3: ${JavaClass.goo3()}")
        println("javaClass foo1: ${super.foo1()}")
        println("javaClass foo2: ${super.foo2()}")
        println("javaClass foo3: ${super.foo3()}")
        println("javaClass foo4: ${super.foo4()}")

        println("CangjieInvoke foo1: ${this.foo1()}")
        println("CangjieInvoke foo2: ${this.foo2()}")
        println("CangjieInvoke foo3: ${this.foo3()}")
        println("CangjieInvoke foo4: ${this.foo4()}")
        println("CangjieInvoke goo1: ${CangjieInvoke.goo1()}")
        println("CangjieInvoke goo2: ${CangjieInvoke.goo2()}")
        println("CangjieInvoke goo3: ${CangjieInvoke.goo3()}")
    }

    public func foo1(): Int32 {
        return 151
    }

    public func foo2(): Int32 {
        return 152
    }

    public func foo3(): Int32 {
        return 153
    }

    public func foo4(): Int32 {
        return 154
    }

    public static func goo1(): Int32 {
        return -1
    }

    public static func goo2(): Int32 {
        return -2
    }

    public static func goo3(): Int32 {
        return -3
    }
}
