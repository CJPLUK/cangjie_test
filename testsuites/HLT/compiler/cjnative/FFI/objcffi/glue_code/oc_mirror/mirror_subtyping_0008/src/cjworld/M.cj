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
public open foreign class M {
    @ForeignName["init"]
    public init()
    @ForeignName["f1:"]
    public open func f1(a: Int64): Unit
    @ForeignName["f2:"]
    public static func f2(a: Int64): Unit
    public mut prop p1: Int64
    public static mut prop p2: Int64
}
