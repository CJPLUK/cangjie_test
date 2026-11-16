// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    let m: M

    public A() {
        m = M()
        println("cj: A()")
        println("x is ${x} during A init")
        println("initialize m prop inside A, expect bunch of init calls")
    }

    @ForeignName["modify"]
    public func modifyParentMirrorFields(): Unit {
        x += 123
        println("Modifying inherited x from cj, new value: ${x}")

        m.x = 987
        println("Modifying m.x from cj, new value: ${m.x}")

        m.k = K(2)
        println("Modifying m.k from cj, new version: ${m.k.version}")

        m.l = m.getLInstance(2)
        println("Modifying m.l from cj, new version: ${m.l.version}")
    }
}
