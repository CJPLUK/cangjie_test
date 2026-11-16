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
    public init() {}
    public open func foo() {
        var m = M()
        if (!m.a2.isNull() && m.a1 == m.a2.read()) {
            println("in cangjie foo, ${m.a2.read()}")
            m.a2.write(321)
            println("in cangjie foo, ${m.a2.read()}")
        }
    }
}
