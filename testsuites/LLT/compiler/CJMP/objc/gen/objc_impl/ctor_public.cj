// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) RUN-EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %overflowOpt %import_objc_interop
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./objc-gen/A.m | compare %f

/* SCAN-IN
- (id)initWithM:(M*)m {
    self.$registryId = -1;
    self = (__bridge_transfer A*)CJImpl_ObjC_cjworld_A_initWithM_T1_PuCN7cjworld5A$regEECN7cjworld1ME((__bridge void*)self, (__bridge_retained void*)m);
*/

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {
    init()
}

@ObjC
public class A <: M {
    @ForeignName["initWithM:"]
    public init(m: M) {
    }
}
