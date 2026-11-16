// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

import objc.lang.*

func a(): ObjCFunc<Unit> {
    return unsafe { zeroValue() }
}

func b(): ObjCFunc<Float64> {
    return unsafe { zeroValue() }
}

func c(): ObjCFunc<String> {
    return unsafe { zeroValue() }
}

func d(): ObjCFunc<(String) -> Float64> {
    return unsafe { zeroValue() }
}

func e(): ObjCFunc<(Int64, ObjCPointer<Int64>, String) -> Float64> {
    return unsafe { zeroValue() }
}

func f(): ObjCFunc<(Unit) -> Float64> {
    return unsafe { zeroValue() }
}


// ASSERT: scan-6 sema_objc_func_argument_must_be_objc_compatible
// ASSERT: scan-6 'ObjCFunc' can only be used with function type over Objective-C compatible types
// ASSERT: scan "Errors": 6
