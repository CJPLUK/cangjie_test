// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output 2>& 1 | compare %f

@ForeignName["bar"]
public func foo() {
}

// ASSERT: scan parse_foreign_name_on_ffi_decl_member
// ASSERT: scan "Errors": 1
