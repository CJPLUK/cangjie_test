// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A branching expr that may yield an external @local! is inferred as @local?, so it cannot be
// returned where an external @local! is required.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func ifExternal(a: String @local!, c: Bool): String @local! {
    if (c) { "x" } else { a }
}

func matchExternal(a: String @local!, n: Int64): String @local! {
    match (n) {
        case 0 => "x"
        case _ => a
    }
}

func tryExternal(a: String @local!): String @local! {
    try { "x" } catch (_: Exception) { a }
}

main() {}

// ASSERT: scan-3 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 3,
