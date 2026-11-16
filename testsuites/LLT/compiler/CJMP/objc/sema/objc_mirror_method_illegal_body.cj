// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan error: member function 'twoParams' of '@ObjC' foreign declaration cannot have body

import objc.lang.*

@ObjC
public foreign class N {
    init()

    @ForeignName["twoParams:second:"]
    public func twoParams(first: Bool, second: Float64): Unit {
        // Should not be accepted
    }
}
