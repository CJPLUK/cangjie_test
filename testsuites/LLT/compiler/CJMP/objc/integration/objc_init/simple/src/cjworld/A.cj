// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    private init() {}

    public static func test(): Unit {
        print("cj: A.test()\n", flush: true)

        let m1 = M.initWithBool(false)
        let m2 = M.initWithBool(true)
        let m3 = M.initWithBoolAndBool(true, false)
        let m4 = M.initWithBoolAndBool(false, true)

        print("cj: A.test() end\n", flush: true)
    }
}
