// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class D {
    public init(this @ local!) { exclave {} }
}
class C {
    var field: D
    public init(this @ local!) { exclave { field = D() @ local! } }
}

func f(p: C @ local!): Int64 {
    match ((((p)))) {
        case b => b.field = D() @ local!
    }
    0
}

main(): Int64 { let _ = f(C() @ local!); 0 }

// ASSERT: scan-1 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 1,
