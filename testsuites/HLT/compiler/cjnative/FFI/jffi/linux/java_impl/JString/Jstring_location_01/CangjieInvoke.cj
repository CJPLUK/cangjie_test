/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java com UNNAMED
// (Android) EXEC: cat UNNAMED/src/*.cj
// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=.
// (Android) EXEC: %javac %cp_loader_jar Main.java com/*.java CangjieInvoke.java -h . -d .
// (Android) EXEC-PIPE: %java %cp_loader_jar -Djava.library.path=. Main 2>&1 | compare %f
// (Android) ASSERT: scan run java Main
// (Android) ASSERT: scan in JavaClass loaction_return
// (Android) ASSERT: scan JavaClass loaction_return1
// (Android) ASSERT: scan in JavaClass Init
// (Android) ASSERT: scan in JavaClass loaction_param:
// (Android) ASSERT: scan in CangjieInvoke Init
// (Android) ASSERT: scan in CangjieInvoke Func1
// (Android) ASSERT: scan in CangjieInvoke Func2

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("in CangjieInvoke Init")
    }

    public func test1(): JString {
        println("in CangjieInvoke Func1")
        let str: String = JavaClass().loaction_return()
        return JString(str + "1")
    }

    public func test2() {
        println("in CangjieInvoke Func2")
        JavaClass().loaction_param(JString())
    }
}
