// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f %diag_json -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan sema_objc_impl_must_have_objc_mirror_super_class

import objc.lang.*

@ObjC
public class N <: I {
    init() {}

    public func foo(): Unit {
      println("Currently not supported")
    }
}

@ObjC
public foreign interface I {
    func foo(): Unit
}
