// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    @ForeignName["init"]
    public init() {
        super(false)
        print("cj: A()\n", flush: true)
    }

    @ForeignName["initWithA:"]
    public init(a: M) {
        super(a, true)
        print("cj: A(M)\n", flush: true)
    }

    @ForeignName["initWithA:andM:"]
    public init(a: A, m: M) {
        super(a, m)
        print("cj: A(A, M)\n", flush: true)
    }
}
