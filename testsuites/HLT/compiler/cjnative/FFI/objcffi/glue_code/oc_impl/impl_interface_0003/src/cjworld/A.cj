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
public class A <: NSObject & I2 {
    private var a = 0
    public init() {}
    public mut prop p1: Int64 {
        get() {a}
        set(v) {a=v}
    }
    public prop p2: Int64 {
        get() {2}
    }
    public func f1() { println("in cj f1") }
    public func f2() { println("in cj f2") }
    public func f3() { println("in cj f3") }
}
