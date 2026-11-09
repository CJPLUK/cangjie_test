// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1
extend Int32 {
    func foo() {
        1
    }
    func foo(this @local!) {
        0
    }
}

main() {
    let a: Int64 @local! = 0
    Int32(a) @local!.foo()
}

// ASSERT: scan-1 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 1,
