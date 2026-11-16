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
    public open func aFoo(p0: ?P): ?P {
        println("p0.isSome() = ${p0.isSome()}")
        p0?.pFoo()
        p0
    }
}
