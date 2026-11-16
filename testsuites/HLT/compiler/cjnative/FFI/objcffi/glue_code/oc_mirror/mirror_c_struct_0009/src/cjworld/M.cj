/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

package cjworld
 
import objc.lang.*

@C
public struct S {
    public var x: Int64 = 0
    public var y: M1 = M1(0)
}

@ObjC
public open foreign class M {
    public init()
    public open func goo(): S
}
