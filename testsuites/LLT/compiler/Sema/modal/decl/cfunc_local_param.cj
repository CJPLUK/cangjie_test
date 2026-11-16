// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1
@C
func foo(a: Int64 @local?): Int64 @local! {
    a + 1
}
func bar() {
    let p: CFunc<(Int64@local!)-> Int64@local?> = { a => a + 3 }
    p
}
main() {}
// ASSERT: scan-4 "DiagKind": "sema_expected_data_type",
// ASSERT: scan "Errors": 4,
