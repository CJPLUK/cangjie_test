/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package cjworld

import objc.foundation.NSObject
import objc.lang.*

@ObjC
public class A <: M {
    public init() {}
    public func f() {
        this.p1 = 1
        println("p1: ${this.p1}")
        println("p2: ${this.p2}")
        this.f1()
        this.f2()
        this.f3()
    }
}
