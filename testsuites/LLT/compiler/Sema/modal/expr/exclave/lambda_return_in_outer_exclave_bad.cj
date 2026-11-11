// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class C {
    init(this @local!) { exclave {} }
}

func explicitReturn(_: C @local!): () -> C @local! {
    exclave {
        let lam = { =>
            let z = C() @local!
            return z
        }
        return lam
    }
}

func implicitReturn(_: C @local!): () -> C @local! {
    exclave {
        let lam = { => C() @local! }
        return lam
    }
}

func nestedFunction(_: C @local!): () -> C @local! {
    exclave {
        func inner(): C @local! {
            return C() @local!
        }
        return inner
    }
}

main() {}

// ASSERT: scan-3 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 3,
