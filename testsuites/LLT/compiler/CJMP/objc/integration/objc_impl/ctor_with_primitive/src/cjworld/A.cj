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
    public init(b: Bool) {
        print("cj: A(${b})\n", flush: true)
        someValue = 10
    }

    @ForeignName["initWithI:"]
    public init(i: Int64) {
        print("cj: A(${i})\n", flush: true)
        someValue = 10
    }

    @ForeignName["initWithA:andB:"]
    public init(a: Int64, b: Bool) {
        print("cj: A(${a}, ${b})\n", flush: true)
        someValue = 10
    }

    @ForeignName["initWithA:andB:andD:"]
    public init(a: Int64, b: Bool, d: Int8) {
        print("cj: A(${a}, ${b}, ${d})\n", flush: true)
        someValue = 10
    }

    public func check() {
        if (someValue != 10) {
            throw Exception("A is in inconsistent state!")
        }
        print("cj: A.check() OK\n", flush: true)
    }
}
