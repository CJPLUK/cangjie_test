// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-5 error: 'ObjCBlock' can only be used with function type over Objective-C compatible types

import objc.lang.*

func a(): ObjCBlock<Unit> {
    return unsafe { zeroValue() }
}

func b(): ObjCBlock<Float64> {
    return unsafe { zeroValue() }
}

func c(): ObjCBlock<String> {
    return unsafe { zeroValue() }
}

func d(): ObjCBlock<(String) -> Float64> {
    return unsafe { zeroValue() }
}

func e(): ObjCBlock<(Unit) -> Unit> {
    return unsafe { zeroValue() }
}
