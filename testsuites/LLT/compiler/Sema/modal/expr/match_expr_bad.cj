// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

func matchExternal(a: String @local!, n: Int64) {
    let x: String @local! = match (n) {
        case 0 => "x"
        case _ => a
    }
}

func matchInternal(n: Int64): String @local! {
    match (n) {
        case 0 => "x"
        case _ => "y"
    }
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-1 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
