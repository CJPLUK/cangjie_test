// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public var cjField: Int64

    public init() {
        println("cj: A()")
        cjField = 123
        foo = 42
        println("cj: ${foo}")
        println("cj: ${super.foo}")
        super.foo = 43
        bar = M1(3.14)
        println("cj: ${super.bar.answer}")
    }
}
