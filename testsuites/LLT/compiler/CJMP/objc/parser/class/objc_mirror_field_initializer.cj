// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %frontendCompiler %cmp_opt %diag_json %f -o %output 2>& 1 | compare %f

@ObjC
foreign class M {
    public let x = 42
    public var xm = 123
}

// ASSERT: scan-2 parse_objc_mirror_field_cannot_have_initializer
// ASSERT: scan "Errors": 2
