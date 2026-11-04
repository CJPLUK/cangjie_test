// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
    var x: Int64 = 0
}

func f(c: C @local!) {
    c[0] = 1
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_cannot_assign_to_subscript",
// ASSERT: scan "Errors": 1,
