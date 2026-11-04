// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
    func foo(this @local!): Int64 { 1 }
}

func bar1(c: C @local!) {
    let h: (()->Unit) = { => println(c.foo()) }
}

func bar2(c: C @local!) {
    let h: (()->Unit)@local? = { => println(c.foo()) }
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 2,
