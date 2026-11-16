// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

import objc.lang.*

@ObjC
public foreign interface I {
    func f1(): Unit
}

@ObjC
public foreign interface J <: I {
    func f2(): Unit
}

@ObjC
open foreign class M {
    init()
}

@ObjC
public class A <: M & J & ObjCId {
    public init() {}
    public func f1(): Unit {}
    public func f2(): Unit {}
}
