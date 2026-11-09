// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
}

main() {
    let c: C @local! = C()
    let d = -c
}

// ASSERT: scan-1 "DiagKind": "sema_invalid_unary_expr",
// ASSERT: scan "Errors": 1,
