// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json --error-count-limit=all %f -o %output 2>&1 | compare %f

class C {
    init() {}
    init(this @local!) {
        exclave {}
    }
    prop my: Int64 {
        get() { 3 }
    }
}

main() {
    let c: C @local! = C()
    let b = c.my
    println(b)
}
// ASSERT: scan "DiagKind": "sema_no_match_prop_accessor_for_call",
// ASSERT: scan "Errors": 1,
