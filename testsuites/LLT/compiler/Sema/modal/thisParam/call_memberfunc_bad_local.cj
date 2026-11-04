// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -o %output %diag_json 2>&1 | compare %f

class C {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
    func p(this @local!) {
        println("C.p @local!")
    }
}

struct S {
    init(this @local!) {
        exclave { }
    }
    init(this @local?) {
        exclave {}
    }
    init() {
        println("S.init")
    }
    func p(this @~local) {
        println("C.p @local!")
    }
}

main() {
    let c: C@local? = C()
    c.p()
    let c2: C = C()
    c2.p()
    let s: S@local! = S()
    s.p()
    let s2: S@local? = S()
    s2.p()
}

// ASSERT: scan-4 "DiagKind": "sema_no_match_function_declaration_for_call",
// ASSERT: scan "Errors": 4,
