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
    @ForeignName["initWithA:AndB:AndC:"]
    public init(a: Int64, b: Float64, c: Bool) {
        println("in cangjie init, a: ${a}, b: ${b}, c: ${c}")
    }
}
