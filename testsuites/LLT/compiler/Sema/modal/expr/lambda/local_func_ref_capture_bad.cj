// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit all 2>&1 | compare %f

class Foo {
    var v: Int64 = 0
    init(this @local!) { exclave { v = 42 } }
}
func mk(): Foo @local! { exclave { return Foo() @local! } }
func outer(): () -> Int64 {
    let x: Foo @local? = mk()
    @local? func read(): Int64 { x.v }
    func direct(): Int64 { read() }
    func alias(): Int64 {
        let r = read
        r()
    }
    func wrapped(): Int64 { ((read))() }
    let inferred = { => read() }
    func useInferred(): Int64 { inferred() }
    return { => 0 }
}
main() {}

// ASSERT: scan-4 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 4,
