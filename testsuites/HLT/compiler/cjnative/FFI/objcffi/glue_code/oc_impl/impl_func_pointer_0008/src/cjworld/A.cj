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
public class A <: M2 {
    public init() {}
    public open func f1(): ObjCFunc<(?I) -> Unit> {
        this.fptr
    }
    public open func f2() {
        var v: I = M1() as I
        f1().call(v)
    }
}
