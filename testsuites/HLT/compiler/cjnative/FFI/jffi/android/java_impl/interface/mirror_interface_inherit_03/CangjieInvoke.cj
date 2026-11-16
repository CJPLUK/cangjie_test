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
// (Android) EXEC: %java %java_mirror_gen com.I1

// (Android) EXEC: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj UNNAMED/src/*.cj
// (Android) RUN-EXEC: %run %run_opt %output %run_args

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
        Logger.println("in CangjieInvoke bar")
        return 10
    }

    public func test(a: Int32) {
        Logger.println("in CangjieInvoke Func")
        var v1 = this.goo(this.foo())
        Logger.println("CangjieInvoke goo: ${v1}")
        var _v2 = I1.bar()
        Logger.println("I1 bar: ${_v2}")
        var v2 = CangjieInvoke.bar()
        Logger.println("CangjieInvoke bar: ${v2}")
    }
}
