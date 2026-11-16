// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

let g = exclave {
    let value: Int64 = true
    value
}

let h: Int64 = exclave {
    let value = missingGlobal
    0
}

class C {
    static let s = exclave {
        let value: Int64 = false
        value
    }

    static let t: Int64 = exclave {
        let value = missingStatic
        0
    }
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_cannot_convert_literal",
// ASSERT: scan-2 "DiagKind": "sema_undeclared_identifier",
// ASSERT: scan-4 "DiagKind": "sema_exclave_outside_function",
// ASSERT: scan "Errors": 8,
