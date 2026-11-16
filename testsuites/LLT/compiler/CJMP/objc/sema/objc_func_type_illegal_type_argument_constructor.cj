// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-14 error: 'ObjCFunc' can only be used with function type over Objective-C compatible types

package objc.test

import objc.lang.*

let invalidFuncPtr = CPointer<CFunc<() -> Unit>>()

func a() {
    return ObjCFunc<Unit>(invalidFuncPtr)
}

func b() {
    return ObjCFunc<Float64>(invalidFuncPtr)
}

func c() {
    return ObjCFunc<String>(invalidFuncPtr)
}

func d() {
    return ObjCFunc<(String) -> Float64>(invalidFuncPtr)
}

func e(): ObjCFunc<Unit> {
    return ObjCFunc(invalidFuncPtr)
}

func f(): ObjCFunc<Float64> {
    return ObjCFunc(invalidFuncPtr)
}

func g(): ObjCFunc<String> {
    return ObjCFunc(invalidFuncPtr)
}

func h(): ObjCFunc<(String) -> Float64> {
    return ObjCFunc(invalidFuncPtr)
}

func i(): ObjCFunc<(Unit) -> Float64> {
    return ObjCFunc(invalidFuncPtr)
}
