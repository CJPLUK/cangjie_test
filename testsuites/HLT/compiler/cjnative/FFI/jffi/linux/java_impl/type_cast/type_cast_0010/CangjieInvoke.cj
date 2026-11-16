/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: Main.java
// (Android) EXEC-PIPE-1: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f --output-javagen-dir=. 2>&1 | compare %f
// (Android) ASSERT: scan sema_java_impl_cannot_be_extended_with_interface

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        println("run cj")
        let a = CangjieTest() as I
        println("is ${a.getOrThrow().test()}")
    }
}

interface I {
    func test() {
        true
    }
}

@Java
public class CangjieTest <: JObject {
    public init() {
        println("CangjieTest")
    }
}

extend CangjieTest <: I {}
