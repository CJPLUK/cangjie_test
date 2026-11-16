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
// (Android) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=. 2>&1 | compare %f
// (Android) ASSERT: scan sema_abstract_method_cannot_be_accessed_directly

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JavaClass {
    public init() {
        println("in CangjieInvoke Init")
        super.newoo() // abstract func : error
    }

    public func newoo(): Int32 {
        println("in CangjieInvoke newoo")
        return 1234
    }
}
