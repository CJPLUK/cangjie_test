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
public class A <: M2 {
    public init() {}
    public func test() {
        var m2 = M2()
        m2.f1(1)
        M2.f2(2)
        m2.p1 = 3
        M2.p2 = 4
        println("in cangjie test, p1: ${m2.p1}")
        println("in cangjie test, p2: ${M2.p2}")
    }
}
