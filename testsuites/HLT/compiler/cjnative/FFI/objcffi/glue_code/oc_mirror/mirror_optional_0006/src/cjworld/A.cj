/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
 
package cjworld

import objc.lang.*
import objc.foundation.*

@ObjC
public class A <: NSObject & I {
    public init() {}
    public func g() {
        try {
            this.f1()
        } catch(e: ObjCOptionalMethodUnimplementedException) {
            println("cj catch ObjCOptionalMethodUnimplementedException")
        }
        try {
            A.f2()
        } catch(e: ObjCOptionalMethodUnimplementedException) {
            println("cj catch ObjCOptionalMethodUnimplementedException")
        }
    }
}
