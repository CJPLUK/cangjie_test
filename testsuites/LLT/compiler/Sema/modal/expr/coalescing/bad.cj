// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json --error-count-limit=all %f -o %output 2>&1 | compare %f

main() {
    let t: Option<Bool> @local! = Option<Bool>.Some(true) @local!
    let o: Option<Int64> @local! = Option<Int64>.Some(1 + true) @local!
    (Some(1(true)) ?? false) + true
    (t ?? 1) * false
    (o ?? 2(false)) + true

    let err = 1(true)
    err ?? err
    0
}

// ASSERT: scan-1 "DiagKind": "sema_invalid_binary_expr",
// ASSERT: scan-3 "DiagKind": "sema_no_match_operator_function_call",
// ASSERT: scan-1 "DiagKind": "sema_cannot_convert_literal",
// ASSERT: scan "Errors": 5,
