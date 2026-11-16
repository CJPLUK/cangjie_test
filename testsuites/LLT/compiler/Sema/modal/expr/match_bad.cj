// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -o %output 2>&1 | compare %f

open class F {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

func foo(a: F@local!): Int {
    match (a) {
        case x: F => 1
        case _ => 0
    }
    match(a) {
        case x: F => 2
        case _ => 0
    }
}

func bar(a: F@~local): Int {
    match (a) {
        case x: F => 1
        case _ => 0
    }
}

main() {
    bar(F())
    foo(F())
    baz(F())
    0
}

// ASSERT: scan-3 "DiagKind": "sema_unreachable_pattern",
// ASSERT: scan "Warnings": 3,
