// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// `M` is marked broken by the member check, so `InsertBaseCtorDecl` gives it no base constructor. `N` stays clean,
// and inserting its own base constructor body must not read the one `M` never got.

import objc.lang.*

@ObjC
public open foreign class M {
    init()
    public prop bad: Array<Int64>
}

@ObjC
public open foreign class N <: M {
    init()
}

// ASSERT: scan sema_objc_interop_prop_must_be_objc_compatible
// ASSERT: scan 'Struct-Array<Int64>' is not Objective-C compatible type
// ASSERT: scan-not Internal Compiler Error
