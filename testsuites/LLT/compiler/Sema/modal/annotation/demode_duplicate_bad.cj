// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit=all 2>&1 | compare %f

class D {
    init() {}
}

class C {
    demode demode var dupField: D
    init() { dupField = D() }
}

main() {}

// ASSERT: scan-1 "DiagKind": "parse_duplicate_modifier",
// ASSERT: scan "Errors": 1,
