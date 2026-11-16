// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -Woff all 2>&1 | compare %f

let gGlobal: Int = { => exclave { 10 } }()
class C {
    static var s: Int = { => exclave { 20 } }()
}
main(): Int {
    0
}
// ASSERT: scan-2 "DiagKind": "sema_exclave_invalid_func_signature",
// ASSERT: scan "Errors": 2,
