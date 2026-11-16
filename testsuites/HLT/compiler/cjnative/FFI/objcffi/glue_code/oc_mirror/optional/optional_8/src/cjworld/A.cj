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
    }
    public open func aFoo(p0: M): M {
        let a = A()
        let result = p0.mFoo3(a)
        result.mFoo()
        p0.p2 = a
        let result0 = p0.p2
        result0.mFoo()
        p0
    }
}
