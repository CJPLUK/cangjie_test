// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1
class C {
    init(this @local!) { exclave {} }
    exclave func foo(this @local!) {}

    func bar(this @local!) {
        let a = foo
        let b = this.foo
        let c: ()->Unit = foo
        let d: ()->Unit = this.foo
    }
}

main() {
    let v = C()@local!
    let a = v.foo
    let b = v.bar
    let c: ()->Unit = v.foo
    let d: ()->Unit = v.bar
}
// ASSERT: scan-8 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 8,
