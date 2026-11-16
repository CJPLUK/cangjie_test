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
        println("cj: A()")
        let a0 = A1()
        let a1 = A1(true)
        let a2 = A1(false, M())
        let a3 = A1(100500)
    }
}
