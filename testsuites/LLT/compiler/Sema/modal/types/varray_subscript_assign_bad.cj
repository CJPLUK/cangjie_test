// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

struct S {
    var p = 18
    init() {}
    exclave init(this @local!) { p = 19 }
}
func bar(q: S @local!) {
    var a: VArray<S, $2> @local! = [S() @local!, S() @local!]
    a[0] = q
    exclave {
        var b: VArray<S, $2> @local? = [S() @local!, S() @local!]
        b[0] = q
    }
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-1 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 2,
