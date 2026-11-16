// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave { } }
    func foo(this @local!) {}
}

func bar() {}

main() {
    let a = bar()@local!
    let b = C()@local!.foo()@local!
}

// ASSERT: scan-2 "DiagKind": "sema_mode_on_non_constructor_call",
// ASSERT: scan "Errors": 2,
