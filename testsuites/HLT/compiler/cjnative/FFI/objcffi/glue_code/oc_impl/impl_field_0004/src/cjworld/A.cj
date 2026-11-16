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
    public var a: Int64 = 0
    public init(a: Int64) {
        this.a = a
    }
}

@ObjC
public class B <: M {
    public var a: A
    public init(a: A) {
        this.a = a
    }
}
