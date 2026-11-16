// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*


@ObjC
public class A <: M {
    private var someValue: Int64 = 0

    @ForeignName["initWithB:"]
    public init(b: M) {
        print("cj: A(b: ${b.value()})\n", flush: true)
        someValue = 10
    }

    @ForeignName["initWithA:andB:"]
    public init(a: M, b: M) {
        print("cj: A(a: ${a.value()}, b: ${b.value()})\n", flush: true)
        someValue = 10
    }

    @ForeignName["initWithA:andB:andD:"]
    public init(a: M, b: Int8, d: M) {
        print("cj: A(a: ${a.value()}, b: ${b}, d: ${d.value()})\n", flush: true)
        someValue = 10
    }

    public func check() {
        if (someValue != 10) {
            throw Exception("A is in inconsistent state!")
        }
        print("cj: A.check() OK\n", flush: true)
    }
}
