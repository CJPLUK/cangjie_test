// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %compile_lib_opt %diag_json 2>&1 | compare %f

@local? func foo() {}

@local? main() {}
// ASSERT: scan-2 "DiagKind": "parse_expected_decl",
// ASSERT: scan "Errors": 2,
