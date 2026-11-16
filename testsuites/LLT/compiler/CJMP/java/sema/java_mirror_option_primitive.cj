// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt %import_java_interop 2>& 1 | compare %f

import java.lang.JObject

@Java
foreign class M {
    public func foo(a: ?Int64): Unit
}

/**
 * Test note: Option of primitive is not allowed
 */

// ASSERT: scan sema_java_mirror_method_arg_must_be_java_mirror
// ASSERT: scan 'Enum-Option<Int64>' is not java-compatible type
// ASSERT: scan "Errors": 1
