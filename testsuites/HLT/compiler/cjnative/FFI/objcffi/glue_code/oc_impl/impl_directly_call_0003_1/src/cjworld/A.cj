/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package cjworld

import objc.lang.*

@ObjC
public open class A <: M {
    public init() {
        println("in cj A init1")
    }
    public init(a: Int64) {
        println("in cj A init2, ${a}")
    }
}
@ObjC
public class B <: A {
    public init() {
        println("in cj B init1")
    }
    public init(a: Int64) {
        println("in cj B init2, ${a}")
    }
    public func g() {
        var a1 = A()
        var a2 = A(1)
        var b1 = B()
        var b2 = B(1)
        a1.f()
        a2.f()
        b1.f()
        b2.f()
    }
}
