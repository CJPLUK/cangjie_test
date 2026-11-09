// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A branching expr whose result branches are external @local! is only @local?, so it cannot be
// returned as an external value.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func ifDirect(c: Bool, a: String @local!, b: String @local!): String @local! {
    if (c) { a } else { b }
}

func matchDirect(n: Int64, a: String @local!, b: String @local!): String @local! {
    match (n) {
        case 0 => a
        case _ => b
    }
}

func tryDirect(a: String @local!, b: String @local!): String @local! {
    try { a } catch (_: Exception) { b }
}

main() {}

// ASSERT: scan-3 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 3,
