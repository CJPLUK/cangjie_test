// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {   
    public init()
    public var fptr: ObjCFunc<() -> ObjCPointer<Int64>>
}

@ObjC
public class A <: M {
    public init() {}
    public open func f1(): ObjCFunc<() -> ObjCPointer<Int64>> {
        this.fptr
    }
    public open func f2() {
        return f1().call().read()
    }
}
