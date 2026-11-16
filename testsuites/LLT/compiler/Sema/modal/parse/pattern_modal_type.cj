// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json 2>&1 | compare %f

open class F {}
class G <: F {}

func foo(a: F@local!): Int {
    match (a) {
        case x: G@local! => 1
        case x: G@~local => 2
        case x: G@local? => 3
    }
    if (let x: G@local! <- a) {
        1
    } else if (let x: G@~local <- a) {
        2
    } else {
        0
    }
    while (let x: G@local! <- a) {
        1
    }
}

main() {
    foo(F())
}

// ASSERT: scan-6 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 6,
