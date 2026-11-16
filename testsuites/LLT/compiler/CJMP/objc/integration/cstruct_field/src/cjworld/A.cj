// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public init() {
        super()
    }

    public func foo(): Unit {
        var m = M()
        println("in cangjie foo, ${m.s.x + m.s.y}")
        var s = S()
        s.x = 2
        s.y = 14
        m.s = s
        println("in cangjie foo, ${m.s.x + m.s.y}")
    }
}
