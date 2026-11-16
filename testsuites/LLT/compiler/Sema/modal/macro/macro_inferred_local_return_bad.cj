// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %cmp_macro %f %diag_json 2>&1

macro package macro_inferred_local_return_bad
internal import std.ast.*

func makeLocal(): Tokens @local! { throw Exception("not executed") }

public macro Implicit(input: Tokens) {
    makeLocal()
}
public macro Explicit(input: Tokens) {
    return makeLocal()
}

// ASSERT: scan-2 "DiagKind": "sema_mismatched_types",
// ASSERT: scan-2 expected 'Class-Tokens', found 'Class-Tokens @local!'
// ASSERT: scan "Errors": 2,
