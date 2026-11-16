// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

import objc.lang.*

class Foo {}

@ObjC
foreign class M {
   @ForeignName["initWithA:"]
   init(a: Foo)
}

// ASSERT: scan sema_objc_interop_ctor_param_must_be_objc_compatible
// ASSERT: scan 'Class-Foo' is not Objective-C compatible type
// ASSERT: scan "Errors": 1
