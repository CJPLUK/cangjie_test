// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

/*
 * This test checks assumption that Mirrors initialized with
 * init(arg) and @ObjCInit static func behave same in runtime
*/

@ObjC
public class Test <: Base {
    public Test() {}

    @ForeignName["test:"]
    public static func test(): Unit {
        let base = Base(42);
        let base2 = Base.initWithBool(42)
        println("base 1 x = ${base.x}")
        println("base 2 x = ${base2.x}")
        base.baseTest()
        base.baseTest()
    }
}
