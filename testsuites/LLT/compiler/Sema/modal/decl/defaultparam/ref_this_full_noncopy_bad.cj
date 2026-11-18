// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f --output-type=staticlib -Woff all %diag_json 2>&1

class C {
    func g(this @ local!, a!: C @local! = this): Int64 { 0 }
}

main(): Int64 {
    0
}


// ASSERT: scan "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 1,
