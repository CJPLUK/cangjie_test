// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) RUN-EXEC-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %overflowOpt %import_objc_interop
// (CJNATIVE and not Windows) RUN-EXEC-PIPE: %cat ./objc-gen/A.m | compare %f

// ASSERT: scan-not #import "ObjCId.h"

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {
    init()
}

@ObjC
public class A <: M {
    public func paramObjCId(_: ObjCId): Unit {}
    public func paramOptObjCId(_: ?ObjCId): Unit {}
    public func retObjCId(): ObjCId { this }
    public func retOptObjCId(): ?ObjCId { this }
}
