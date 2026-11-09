// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A branching expr with an external @local! result branch is inferred as @local?, which cannot be
// narrowed to @local!.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func ifBranch(c: Bool, a: String @local!) {
    let x: String @local! = if (c) { a } else { "x" }
}

func matchBranch(n: Int64, a: String @local!) {
    let x: String @local! = match (n) {
        case 0 => "x"
        case _ => a
    }
}

func tryBranch(a: String @local!) {
    let x: String @local! = try { "x" } catch (_: Exception) { a }
}

main() {}

// ASSERT: scan-3 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-3 "Message": "cannot assign external @local?
// ASSERT: scan "Errors": 3,
