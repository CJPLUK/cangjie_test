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

    @ForeignName["initWithValue:"]
    public init(value: Int64) {
        print("cj: A(${value})\n", flush: true)
        someValue = value
    }

    @ForeignName["initWithB:"]
    public init(b: A) {
        print("cj: A(b: ${b.someValue})\n", flush: true)
        someValue = b.someValue
    }

    @ForeignName["initWithA:andB:"]
    public init(a: A, b: A) {
        print("cj: A(a: ${a.someValue}, b: ${b.someValue})\n", flush: true)
        someValue = a.someValue + b.someValue
    }

    @ForeignName["initWithA:andB:andD:"]
    public init(a: A, b: Int8, d: A) {
        print("cj: A(a: ${a.someValue}, b: ${b}, d: ${d.someValue})\n", flush: true)
        someValue = Int64(b)
    }

    public func printValue(): Unit {
        print("cj: A.value = ${someValue}\n", flush: true)
    }
}
