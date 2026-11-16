// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class C {
    public var v: Int64 = 1
    init(this @ ~local) {}
    exclave init(this @ local!) {}
}

func g5(a: C @ local!): Int64 {
    let x: C @ local? = exclave { a }
    return x.v
}

main(): Int64 {
    let c = C() @local!
    c.v = 555
    println("g5=${g5(c)}")
    0
}

// ASSERT: scan "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 1,
