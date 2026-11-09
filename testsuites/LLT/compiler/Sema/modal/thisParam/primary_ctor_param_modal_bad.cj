// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Primary ctor ordinary params must be @~local; var/let params
// cannot have a modal at all. Spec rule 5.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all --error-count-limit=all 2>&1 | compare %f

class C1 {
    C1(a: Int64 @local!) {}
}

struct S1 {
    S1(a: Int64 @local?) {}
}

class C2 {
    C2(var a: Int64 @local!) {}
}

class C3 {
    C3(let a: Int64 @local?) {}
}

struct S2 {
    S2(var a: Int64 @local!) {}
}

main() {}

// ASSERT: scan-5 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 5,
