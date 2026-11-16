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
        println("in cangjie foo, ${m.sPtr.read().x + m.sPtr.read().y}")
        var s = S()
        s.x = 2
        s.y = 2
        m.sPtr.write(s)
        println("in cangjie foo, ${m.sPtr.read().x + m.sPtr.read().y}")
    }
}
