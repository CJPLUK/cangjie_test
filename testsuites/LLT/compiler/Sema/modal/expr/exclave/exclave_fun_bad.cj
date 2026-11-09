// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    exclave init(this @local!) {}
    exclave func nested(): C @local! {
        exclave { C()@local! }
    }
}
exclave func foo(): Unit {
    println(3)
}
exclave func foo(a: String @local?): Unit {
    println(a)
}
main() {}

// ASSERT: scan-1 "DiagKind": "sema_nested_exclave",
// ASSERT: scan-2 "DiagKind": "sema_exclave_invalid_func_signature",
// ASSERT: scan "Errors": 3,