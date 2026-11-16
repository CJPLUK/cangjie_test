// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

foreign func malloc(size: UIntNative): CPointer<Unit>

@ObjC
public class A <: M {
    public init() {
        println("cj: A()")
        let number = unsafe { CPointer<Int32>(getPointer()).read() }
        println("cj: *getPointer ${number}")
    }

    @ForeignName["initWithAnotherPtr:"]
    public init(ptr: CPointer<Unit>) {
        println("cj: A(ptr: CPointer<Unit>)")
    }

    @ForeignName["initWithTwoPtr:second:"]
    public init(ptr1: CPointer<Unit>, ptr2: CPointer<Unit>) {
        println("cj: A(ptr1: CPointer<Unit>, ptr2: CPointer<Unit>)")
    }

    public func returnPointer(): CPointer<Int32> {
        let ptr = unsafe { CPointer<Int32>(malloc(sizeOf<Int32>())) }
        unsafe { ptr.write(42) }
        return ptr
    }

    public func testConstructors(): Unit {
        let ptr = CPointer<Unit>()
        M(ptr)
        A(ptr)
        A(ptr, ptr)
    }
}
