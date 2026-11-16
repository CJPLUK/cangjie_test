// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json 2>&1 | compare %f

open class C {
    init() {}
    init(this @local!) { exclave { } }
}

func boxInternalToAnyNot(c: C @local!) {
    let a: Any @~local = c
}

main() {
    boxInternalToAnyNot(C()@local!)
} 

// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
