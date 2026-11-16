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
        var p = m.goo()
        if (!p.isNull() && !p.read().isNull()) {
            println("in cangjie foo, ${p.read().read()}")
            p.read().write(321)
            println("in cangjie foo, ${p.read().read()}")
        }
    }
}
