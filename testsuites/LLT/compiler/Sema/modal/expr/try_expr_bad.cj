// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

func tryExternal(a: String @local!) {
    let x: String @local! = try { a } catch (_: Exception) { "x" }
}

func tryInternal(): String @local! {
    try { "x" } catch (_: Exception) { "y" }
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-1 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
