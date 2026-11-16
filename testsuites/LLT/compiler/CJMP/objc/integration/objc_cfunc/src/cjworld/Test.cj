// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@C
func testFunc(i: Int32): Unit {
    println("testFunc() passed to ObjC called, i = ${i}")
}

@ObjC
public class Test <: Base {
    public Test() {}

    @ForeignName["cFuncTestObjCToCj:"]
    public func objCToCj(f: CFunc<()->Bool>): Unit {
        unsafe {
        if (f()) {
            println("f() passed from ObjC called, true")
        } else {
            println("f() passed from ObjC called, false")
        }
        }
    }
    
    @ForeignName["cFuncTestCjToObjC"]
    public func cjToObjC() {
        let b = Base()
        b.callFunction(testFunc, 42)
    }
}
