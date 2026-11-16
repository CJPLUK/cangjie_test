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
public class A <: M {
    public init() {}
    public func g1() { super.f1() }
    public static func g2() { M.f2() }
}
