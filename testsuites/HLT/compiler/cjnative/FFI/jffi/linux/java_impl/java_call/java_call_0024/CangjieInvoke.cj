/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java com
// (Android) EXEC: %java %java_mirror_gen com.JavaClass
// (Android) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f UNNAMED/src/*.cj --output-javagen-dir=. 2>&1 | compare %f
// (Android) ASSERT: scan sema_java_impl_cannot_be_extended_with_interface

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {}
}

interface I {
    public func test() {
        println("run cj")
        return JavaClass().test() || true
    }
}

extend CangjieInvoke <: I {}
