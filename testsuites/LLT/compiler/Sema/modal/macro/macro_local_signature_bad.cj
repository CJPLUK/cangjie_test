// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %cmp_macro %f %diag_json 2>&1

macro package macro_local_signature_bad
internal import std.ast.*

public macro ParamFull(input: Tokens @local!): Tokens { quote() }
public macro ParamHalf(input: Tokens @local?): Tokens { quote() }
public macro ReturnFull(input: Tokens): Tokens @local! { throw Exception("not executed") }
public macro ReturnHalf(input: Tokens): Tokens @local? { throw Exception("not executed") }

// ASSERT: scan-4 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 4,
