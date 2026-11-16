// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class A {
    func foo(this @local!) {}
    func bar() {
        let a = foo
        let b = this.foo

        let c: ()->Unit = foo
        let d: ()->Unit = this.foo
    }
}
main() {}
// ASSERT: scan-4 "DiagKind": "sema_no_match_function_declaration_for_ref",
// ASSERT: scan "Errors": 4,
