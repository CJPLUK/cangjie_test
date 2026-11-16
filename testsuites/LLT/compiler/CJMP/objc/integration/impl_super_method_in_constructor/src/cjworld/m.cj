// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class Base {
    public init()
    public open func bar(): Bool
    @ForeignName["foo:"]
    public open func foo(i: Int64): Int64
}

@ObjC
public class A <: Base {
    public init() {
        super()
        print("cj: A()\n", flush: true)
        super.foo(10)
        super.bar()
        print("cj: end A()\n", flush: true)
    }

    public override func foo(i: Int64): Int64 {
        print("cj: foo(${i})\n", flush: true)
        return i - 1
    }

    public override func bar(): Bool {
        print("cj: bar()\n", flush: true)
        return false
    }
}
