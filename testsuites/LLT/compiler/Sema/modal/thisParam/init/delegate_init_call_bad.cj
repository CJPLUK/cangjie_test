// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

class F {
    init(this @local?) {
        exclave {
            a = 3
        }
    }
    init(_: Int) {
        a = 3
    }
    init(this @local!, _: Int) {
        exclave { this() }
    }
    let a: Int
}

main() {
}

// ASSERT: scan-1 "DiagKind": "sema_no_match_function_declaration_for_call",
// ASSERT: scan "Errors": 1,
