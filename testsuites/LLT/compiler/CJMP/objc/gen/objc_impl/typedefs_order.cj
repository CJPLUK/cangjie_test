// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) RUN-EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %overflowOpt %import_objc_interop
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./objc-gen/A.h | compare %f

// ASSERT: scan typedef void(^BlockF0uE)();
// ASSERT: scan typedef BlockF0uE(^BlockF0CN9objc_lang9ObjCBlockIF0uEECN9objc_lang9ObjCBlockIF0uEEE)(BlockF0uE);

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {
    public init()
}

@ObjC
public class A <: M {
    public init() {}
    @ForeignName["initWithP0:p1:p2:"]
    public init(p0: ObjCBlock<(ObjCBlock<() -> Unit>) -> ObjCBlock<() -> Unit>>) {
        let f = ObjCBlock<() -> Unit>({=> println("nested lambda")})
        p0.call(f)
    }
}
