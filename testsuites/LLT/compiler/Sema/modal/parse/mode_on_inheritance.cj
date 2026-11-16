// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

interface I {}

extend Int64 <: I @ local? {}

open class O {}

class K <: O @ ~local & I @ local! {}

class C <: I @ local? {}

class W<T> where T <: I @ local? {}

interface J <: I @ ~local {}

struct S <: I @ local! {}

enum E <: I @ local? { A }

main(): Int64 {
    return 0
}

// ASSERT: scan-8 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 8,
