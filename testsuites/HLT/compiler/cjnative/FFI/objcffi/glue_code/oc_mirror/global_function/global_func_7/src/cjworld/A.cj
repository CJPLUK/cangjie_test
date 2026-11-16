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
    public open func foo(): Unit {
        println("in cangjie foo")
        let a = A()
        let f = this.fptr
        let result = global_func(a as P, a, f)
        result?.pFoo()
    }
}
