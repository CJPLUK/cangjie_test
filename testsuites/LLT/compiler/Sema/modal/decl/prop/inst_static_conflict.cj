// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    static prop p: String {
        get() { "" }
    }
    prop p: String @local! {
        get() { exclave { "" } }
    }
}

struct S {
    prop p: String {
        get() { "" }
    }
}

extend S {
    prop p: String @local! {
        get() { exclave { "" } }
    }
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_static_prop_overload",
// ASSERT: scan "Errors": 1,
