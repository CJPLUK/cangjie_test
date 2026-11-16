// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    exclave init(this @local!) {}
    mut prop p: Int64 @local! {
        get() { 0 }
        set(v) { }
    }
    mut prop p: Int64 @local! {
        get() { 1 }
        set(w) { }
    }
}
main() {
    let c = C() @local!
    c.p
}

// ASSERT: scan "DiagKind": "sema_redefinition",
// ASSERT: scan "Errors": 1,
