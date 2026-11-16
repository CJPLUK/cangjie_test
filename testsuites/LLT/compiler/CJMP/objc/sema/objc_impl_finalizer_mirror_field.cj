// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// A field of an @ObjC foreign is written as a field but names an instance variable of the Objective-C object
// the mirror stands for, reached through that object's handle. The user finalizer of an @ObjC is moved
// into the registry companion, which is built to outlive the escaping peer, so by the time it runs the peer
// has been deallocated and there is nothing left to read. It has to be rejected, like a mirror's method is,
// rather than desugared into a call the companion cannot make.
// ASSERT: scan error: instance field of an Objective-C mirror cannot be used in the finalizer
// ASSERT: scan-not Internal Compiler Error

import objc.lang.*

@ObjC
public open foreign class M {
    public var foo: Int64
    public init()
}

@ObjC
public class A <: M {
    public init() {
        foo = 1
    }

    ~init() {
        foo = foo + 1
    }
}
