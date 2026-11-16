// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
    prop p: Int64 @local! {
        get() { 0 }
    }
}

func f() {
    var c: C = C()
    let x = c.p
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_no_match_prop_accessor_for_call",
// ASSERT: scan "Errors": 1,
