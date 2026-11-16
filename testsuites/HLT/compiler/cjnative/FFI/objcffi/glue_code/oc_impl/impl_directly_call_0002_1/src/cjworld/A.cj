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
    public init() {}
    public init(a: Int64) {
        println("in cj A, ${a}")
    }
}

@ObjC
public class B <: A {
    public init() {
        super()
        super.f()
    }
    public init(a: Int64) {
        super(a)
        super.f()
        println("in cj B, ${a}")
    }
}
