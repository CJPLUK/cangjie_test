// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    prop p: Int64 {
        get() { 1 }
    }
    prop p: String {
        get() { "x" }
    }
}
main() {}

// ASSERT: scan "DiagKind": "sema_prop_redefinition",
// ASSERT: scan "Errors": 1,
