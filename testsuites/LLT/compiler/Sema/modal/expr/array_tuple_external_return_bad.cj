// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An array/tuple literal is allocated in the current region, so it is internal and cannot be
// returned as an external @local! value.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func arrayExternal(a: String @local!): Array<String> @local! {
    [a, a]
}

func tupleExternal(a: String @local!): (String, String) @local! {
    (a, a)
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
