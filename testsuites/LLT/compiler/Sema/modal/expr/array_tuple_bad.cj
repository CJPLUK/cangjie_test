// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

func arrayExternal(a: String @local!) {
    let x: Array<String> @local! = [a]
}

func arrayInternal(): Array<String> @local! {
    ["x", "y"]
}

func tupleExternal(a: String @local!) {
    let x: (String, String) @local! = ("x", a)
}

func tupleInternal(): (String, String) @local! {
    ("x", "y")
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-2 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 4,
