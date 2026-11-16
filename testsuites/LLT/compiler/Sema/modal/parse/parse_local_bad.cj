// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %compile_lib_opt %diag_json 2>&1 | compare %f

func foo() {
    let a: Int @local
}
func bar() {
    let b: Int @~ local
}

// ASSERT: scan-2 "DiagKind": "parse_expected_character",