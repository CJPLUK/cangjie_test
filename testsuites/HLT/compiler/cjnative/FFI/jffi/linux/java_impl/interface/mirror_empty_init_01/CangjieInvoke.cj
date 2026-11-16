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
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java CangjieInvoke_Father.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan in CangjieInvoke Func
// (Android) ASSERT: scan in CangjieInvoke_Father Func

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke_Father <: JObject {
    // bug1
    // public init() {}

    public func test(): Bool { // static is ok
        println("in CangjieInvoke_Father Func")
        false
    }
}

@Java
public class CangjieInvoke <: JObject {
    // bug2
    // public init() {
    //     println("in CangjieInvoke Init")
    // }

    public func test() {
        println("in CangjieInvoke Func")
        return CangjieInvoke_Father().test()
    }
}
