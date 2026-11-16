// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public var cjField: CString

    public mut prop cjProp: CString {
        get() { cjField }
        set(v) {
            unsafe { LibC.free(cjField) }
            cjField = v
        }
    }

    public init() {
        cjField = unsafe { LibC.mallocCString("Hello, Cangjie!") }
        println("cj: A()")
    }

    public override func concatFirstAndSecond(first: CString, second: CString): CString {
        unsafe { LibC.mallocCString("${first}${second}") }
    }

    public func testConcatThroughOC() {
        let concatResult = super.concatFirstAndSecond(objCField, cjField)
        println("cj: returned string \"${concatResult}\"")
        unsafe { LibC.free(concatResult) }        
    }

    ~init() {
        unsafe { LibC.free(cjField) }
    }
}
