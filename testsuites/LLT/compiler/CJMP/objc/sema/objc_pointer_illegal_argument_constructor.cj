// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-12 error: 'ObjCPointer' can only be used with Objective-C compatible type

package objc.test

import objc.lang.*

struct Foo {}

func a() {
    // Float16 is not Objective-C compatible
    return ObjCPointer<Float16>(CPointer<Unit>())
}

func b() {
    return ObjCPointer<Foo>(CPointer<Unit>())
}

func c() {
    return ObjCPointer<String>(CPointer<Unit>())
}

func d() {
    return ObjCPointer<(String) -> Float64>(CPointer<Unit>())
}

func e(): ObjCPointer<Float16> {
    return ObjCPointer(CPointer<Unit>())
}

func f(): ObjCPointer<Foo> {
    return ObjCPointer(CPointer<Unit>())
}

func g(): ObjCPointer<String> {
    return ObjCPointer(CPointer<Unit>())
}

func h(): ObjCPointer<(String) -> Float64> {
    return ObjCPointer(CPointer<Unit>())
}
