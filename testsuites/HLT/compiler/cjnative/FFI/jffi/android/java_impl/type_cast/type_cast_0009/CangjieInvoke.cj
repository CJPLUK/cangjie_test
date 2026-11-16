/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// (Android) DEPENDENCE: MainInstrumentedTest.java 
// (Android) ERRCHECK: %compiler %cmp_opt %compile_dylib_opt %jffi_link %f %java_interop_util/logger.cj
// (Android) ASSERT: scan sema_java_impl_cannot_be_extended_with_interface

package UNNAMED

import java.lang.*

@Java
public class CangjieInvoke <: JObject {
    public init() {
        Logger.println("run cj")
        Logger.println("is ${CangjieTest() is I}")
    }
}

interface I {}

@Java
public class CangjieTest <: JObject {
    public init() {
        Logger.println("CangjieTest")
    }
}

extend CangjieTest <: I {}
