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
    public var p1: ObjCPointer<Int64> = unsafe { ObjCPointer<Int64>(CPointer<Unit>()) }
    public var p2: ObjCPointer<Int64> = unsafe { ObjCPointer<Int64>(CPointer<Unit>()) }
    public init() {
        p1 = aPtr
        var cp = unsafe { LibC.malloc<Int64>() }
        unsafe { cp.write(666) }
        p2 = unsafe { ObjCPointer<Int64>(CPointer<Unit>(cp)) }
        p1.write(p1.read() + 1)
        p2.write(p2.read() + 1)
    }
}
