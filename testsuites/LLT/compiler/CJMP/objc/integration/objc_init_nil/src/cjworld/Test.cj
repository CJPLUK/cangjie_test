// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class Test <: Base {
    public Test() {}
    
    @ForeignName["cFuncTestCjToObjC"]
    public func cjToObjC() {
        try {
            let b = Fraction(0, 0)
        } catch (e: ObjCInitException) {
            println(e.toString())
        }

        try {
            let b = Fraction.initWithNumAndDenom2(0, 0)
        } catch (e: ObjCInitException) {
            println(e.toString())
        }
    }
}
