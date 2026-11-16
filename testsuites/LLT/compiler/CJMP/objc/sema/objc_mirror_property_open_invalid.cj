// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan error: cannot override property 'a'
// ASSERT: scan note: the parent property is not modified by 'open'

package cjworld

import objc.lang.*

@ObjC
public open foreign class Base {
    public prop a: Int64
}

@ObjC
foreign class Derived <: Base {
    public prop a: Int64
}
