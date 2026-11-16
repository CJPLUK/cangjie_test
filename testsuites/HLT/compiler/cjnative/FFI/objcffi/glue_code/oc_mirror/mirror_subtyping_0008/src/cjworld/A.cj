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
public class A <: M {
    public init() {
        super()
        test()
    }
}

func test() {
    var m = M()
    m.f1(1)
    M.f2(2)
    m.p1 = 3
    M.p2 = 4
    println("in cangjie test, p1: ${m.p1}")
    println("in cangjie test, p2: ${M.p2}")
}
