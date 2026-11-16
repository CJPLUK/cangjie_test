// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan error: only foreign or exported '@ObjC' declaration can inherit super Objective-C declaration
// ASSERT: scan 'K' must be annotated with either '@ObjC' or '@ObjC foreign'

import objc.lang.*

public class K <: N {
    init() {}
}

@ObjC
public open class N <: M {
    init() {}
}

@ObjC
public open foreign class M {
    init()
}
