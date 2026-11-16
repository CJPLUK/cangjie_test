// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json -Woff all 2>&1
class C {
    exclave init(this @local!) {}
    func foo(this @local!, c: C @local!) {
        bar()
        this.bar()
        c.bar()
    }
    func bar(this @local!) {}
}
main() {}
// ASSERT: scan-3 "DiagKind": "sema_external_local_arg",
// ASSERT: scan "Errors": 3,
