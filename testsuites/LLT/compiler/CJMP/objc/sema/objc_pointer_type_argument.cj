// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import objc.lang.*

func ptrToPrimitive(): ObjCPointer<Float64> {
    return unsafe { zeroValue() }
}

func ptrToPointer(): ObjCPointer<ObjCPointer<Float64>> {
    return unsafe { zeroValue() }
}

func ptrToMirror(): ObjCPointer<Moo> {
    return unsafe { zeroValue() }
}

func ptrToImpl(): ObjCPointer<Foo> {
    return unsafe { zeroValue() }
}

@ObjC
public open foreign class Moo {
    init()
}

@ObjC
class Foo <: Moo {}
