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
        let m = M()
    }

    public func boo(): Bool {
        println("cj: A.boo(): M()")
        let m = M()
        println("cj: A.boo(): M1()")
        let m1 = M1()

        let mGoo = m.goo()
        let m1Goo = m1.goo()
        println("cj: A.boo(): ${mGoo} > ${m1Goo}")
        mGoo > m1Goo
    }
}
