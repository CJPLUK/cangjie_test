// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A1 <: M {
    public A1() {
        println("cj: A1()")
    }

    @ForeignName["initWithA:"]
    public init(a: Bool) {
        this()
        println("cj: A1(bool)")
    }

    @ForeignName["initWithA:andM:"]
    public init(a: Bool, m: M) {
        this(a)
        println("cj: A1(Bool, M)")
    }

    @ForeignName["initWithC:"]
    public init(c: Int64) {
        super(c > 0)
        println("cj: A1(Int64)")
    }
}
