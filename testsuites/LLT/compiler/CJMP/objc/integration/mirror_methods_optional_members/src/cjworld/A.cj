// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public init() {
        super()
    }

    @ForeignName["runFromCJ"]
    public static func runFromCJ(): Unit {
        let m = M()
        m.implemented()
        try {
            m.unimplemented()
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: caught ObjCOptionalMethodUnimplementedException!")
        }
        m.implementedWithArg(2)
        try {
            m.unimplementedWithArg(2)
        } catch (e: ObjCOptionalMethodUnimplementedException) {
            println("cj: caught ObjCOptionalMethodUnimplementedException!")
        }
    }
}
