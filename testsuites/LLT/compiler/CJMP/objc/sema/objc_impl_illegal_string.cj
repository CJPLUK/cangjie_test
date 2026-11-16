// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

import objc.lang.*

@ObjC
public class N <: M {
    init() {}

    @ForeignName["format:"]
    public func format(name: String): String {
        "Hello, " + name + "!"
    }
}

@ObjC
public open foreign class M {
    init()
}

// ASSERT: scan sema_objc_interop_method_ret_must_be_objc_compatible
// ASSERT: scan sema_objc_interop_method_param_must_be_objc_compatible
// ASSERT: scan 'Struct-String' is not Objective-C compatible type
// ASSERT: scan 'String' is not Objective-C compatible type
// ASSERT: scan "Errors": 2
