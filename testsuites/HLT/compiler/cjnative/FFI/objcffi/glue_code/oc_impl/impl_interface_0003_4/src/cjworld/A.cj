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
        super.p1 = 1
        println("p1: ${super.p1}")
        println("p2: ${super.p2}")
        super.f1()
        super.f2()
        super.f3()
    }
}
