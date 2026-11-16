// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*


@ObjC
public class A <: M {
    @ForeignName["initWithA:andB:"]
    public init(a: Int64, b: Float64) {
        super(a, b)
        println("cj: A(a: ${a}, b: ${b})")
    }

    public init() {
        super(123, 3.14)
        println("cj: A()")
    }

    public static func check(fromObjC: A): A {
        let fromCj = A(fromObjC.a, fromObjC.b)
        println("cj: ${fromCj.a} == ${fromObjC.a}")
        println("cj: ${fromCj.b} == ${fromObjC.b}")
        fromCj
    }
}
