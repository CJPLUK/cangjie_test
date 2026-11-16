// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class Test <: Base {
    public Test() {}

    @ForeignName["letTest:"]
    public func letTest(m: Base): Unit {
        if (let a: A <- m) {
            a.test()
        } else {
            println("not A")
        }
    }
}
