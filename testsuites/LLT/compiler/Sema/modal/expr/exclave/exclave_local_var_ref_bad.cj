// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A non-copy @local! local variable declared outside an exclave
// cannot be referred to from inside the exclave. Spec rule 2.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json 2>&1 | compare %f

class C {
    init() {}
    init(this @local!) { exclave { } }
}

func makeC(): C @local! {
    exclave { C() }
}

func bad(): C @local! {
    var v: C @local! = makeC()
    exclave {
        v
    }
}

main() {}

// ASSERT: scan "DiagKind": "sema_cannot_access_local_var_outside_exclave",
// ASSERT: scan "Errors": 1,
