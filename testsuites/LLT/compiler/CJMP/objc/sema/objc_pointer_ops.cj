// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

import objc.lang.*

func usePtrToPrimitive(v: ObjCPointer<Float64>): ObjCPointer<Float64> {
    if (v.isNull()) { return v }
    println(v.read())
    v.write(3.14)
    return v
}

func usePtrToPointer(v: ObjCPointer<ObjCPointer<Float64>>): ObjCPointer<ObjCPointer<Float64>> {
    if (v.isNull()) { return v }
    println(v.read().read())
    v.read().write(3.14)
    return v
}

func usePtrToMirror(v: ObjCPointer<Moo>): ObjCPointer<Moo> {
    if (v.isNull()) { return v }
    let obj = v.read()
    v.write(obj)
    return v
}

func usePtrToImpl(v: ObjCPointer<Foo>): ObjCPointer<Foo> {
    if (v.isNull()) { return v }
    let obj = v.read()
    v.write(obj)
    return v
}

@ObjC
public open foreign class Moo {
    init()
}

@ObjC
class Foo <: Moo {}
