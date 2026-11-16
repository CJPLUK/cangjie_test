// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output %compile_shared_lib_opt 2>& 1 | compare %f
// ASSERT: scan sema_mismatched_types
// ASSERT: scan expected 'Class-M', found 'Class-P'

import objc.lang.*

public class P {}

@ObjC
foreign class M {
    public init()

    @ObjCInit
    public static func customInit(): P // expected M
}
