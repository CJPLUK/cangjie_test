/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DESCRIPTION: extending @Java class, extended members are not accessible from Java, neither can it be accessed by Cangjie.
// (Android) DEPENDENCE: com MainInstrumentedTest.java  
// (Android) EXEC: %javac com/*.java %java_interop_util/Logger.java
// (Android) EXEC: %java %java_mirror_gen com.Init01
// (Android) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj 2>&1 | compare %f
// (Android) ASSERT: scan "'cjFoo' is not a member of class 'CangjieInvoke'"

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        let class_01 = Init01()
    }
    public func driverFoo(): Unit {
        Logger.println("driverFoo")
        this.cjFoo()
        CangjieInvoke.cjGoo()
    }
}

extend CangjieInvoke {
    public func cjFoo() {
        Logger.println("cjFoo")
    }

    public static func cjGoo() {
        Logger.println("cjGoo")
    }
}
