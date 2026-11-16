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
        var a = m.goo1()
        if (a.read() == 123) {
            var p1 = m.goo2(a)
            if (!p1.isNull()) {
                println("in cangjie foo, ${p1.read()}")
                p1.write(321)
                println("in cangjie foo, ${p1.read()}")
            }
        }
        var cp = unsafe{ LibC.malloc<Int64>() }
        unsafe{ cp.write(666) }
        var p2 = m.goo2(unsafe{ ObjCPointer<Int64>(CPointer<Unit>(cp))})
        if (!p2.isNull()) {
            println("in cangjie foo, ${p2.read()}")
            p2.write(999)
            println("in cangjie foo, ${p2.read()}")
        }
    }
}
