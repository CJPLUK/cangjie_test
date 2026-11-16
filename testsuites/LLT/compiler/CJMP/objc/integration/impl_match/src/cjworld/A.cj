// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open class A <: Base {
    let i: Int32
    public A(a: Int32) { i = a }

    @ForeignName["test"]
    public func test(): Unit {
        println("A.test() called, i = ${i}")
    }
}

@ObjC
public class D <: A {
    public D() { super(-1) }
}
