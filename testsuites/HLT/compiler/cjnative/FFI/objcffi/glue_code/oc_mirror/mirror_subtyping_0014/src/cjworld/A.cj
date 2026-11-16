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
        super.f1(1)
        super.p1 = 3
        println("in cangjie init, p1: ${super.p1}")
    }
    public open func f1(a: Int64): Unit {
        println("in cangjie f1: ${a + 1}")
    }
    public mut prop p1: Int64 {
        get() {
            2
        }
        set(v) {
            v
        }
    }
}
