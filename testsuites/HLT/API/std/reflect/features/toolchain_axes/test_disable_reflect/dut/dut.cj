/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package dut

import std.reflect.*

public class Foo {
    public var f1: Int64 = 11
    public func m(): Unit {}
}

public func dfooIvars(): Int64 {
    (TypeInfo.of(Foo()) as ClassTypeInfo).getOrThrow().instanceVariables.size
}

public func dfooIfuncs(): Int64 {
    (TypeInfo.of(Foo()) as ClassTypeInfo).getOrThrow().instanceFunctions.size
}

public func dfooTypeName(): String {
    TypeInfo.of(Foo()).name
}
