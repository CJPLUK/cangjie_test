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
    public open func foo(): ObjCPointer<S> {
        var s = sPtr.read()
        println("in cangjie foo, ${s.x + s.y}")
        s.x = s.x + 1
        s.y = s.y + 1
        sPtr.write(s)
        sPtr
    }
}
