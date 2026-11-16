// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-9 error: 'ObjCBlock' can only be used with function type over Objective-C compatible types

import objc.lang.*

func a() {
    return ObjCBlock<Unit>(())
}

func b() {
    return ObjCBlock<Float64>(2.0)
}

func c() {
    return ObjCBlock<String>("hello")
}

func d() {
    return ObjCBlock<(String) -> Float64>({_=>2.0})
}

func e() {
    return ObjCBlock(())
}

func f() {
    return ObjCBlock(2.0)
}

func g() {
    return ObjCBlock("hello")
}

func h() {
    return ObjCBlock({x: String => 2.0})
}

func i() {
    return ObjCBlock({x: Unit => x})
}
