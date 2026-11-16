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
// (Android) EXEC: %java %java_mirror_gen com.I1
// (Android) EXEC: cat UNNAMED/src/*.cj
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan in I1 bar
// (Android) ASSERT: scan in CangjieInvoke Func
// (Android) ASSERT: scan CangjieInvoke goo: 10
// (Android) ASSERT: scan I1 bar: 1
// (Android) ASSERT: scan in CangjieInvoke bar
// (Android) ASSERT: scan CangjieInvoke bar: 10

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: I1 {
    public init() {
    }

    public func foo(): ?I1 {
        return this
    }

    public func goo(a: ?I1): Int32 {
        return 10
    }

    public static redef func bar(): Int32 {
        println("in CangjieInvoke bar")
        return 10
    }

    public func test(a: Int32) {
        println("in CangjieInvoke Func")
        var v1 = this.goo(this.foo())
        println("CangjieInvoke goo: ${v1}")
        var _v2 = I1.bar()
        println("I1 bar: ${_v2}")
        var v2 = CangjieInvoke.bar()
        println("CangjieInvoke bar: ${v2}")
    }
}
