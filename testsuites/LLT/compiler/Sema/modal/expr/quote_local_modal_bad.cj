// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

import std.ast.*
main() {
    let tokens: Tokens @local! = quote(let x = 1)
}

// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 1,
