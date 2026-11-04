// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Sanity check: a nested function that captures an outer non-copy
// @local! local var inside its exclave is rejected by the existing
// `sema_bad_capture_local` rule; Rule 2 does not also fire here.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json 2>&1 | compare %f

class C {
    init() {}
    init(this @local!) { exclave { } }
}

func makeC(): C @local! {
    exclave { C() }
}

exclave func outer(): C @local! {
    var v: C @local! = makeC()
    func inner(): C @local! {
        exclave {
            v
        }
    }
    v
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 1,
