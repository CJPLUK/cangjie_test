/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public init() {
    }
    public func testGenerics(): Unit {
        println("cj testGenerics")
        let m = M()
        m.mFoo()
        let b = Box(m)
        b.printContentType()
        // currently, typecasting for ObjCMirror instance is not supported, so ObjCId's correctness can not be tested in Cangjie side, we can just get it and pass it back to ObjC to test its correctness.
        b.content
        let mm = b.getContent()
        m.testBox(mm)
    }
}
