// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -o %output %diag_json 2>&1 | compare %f

class C {
    func foo(this @~local, a: Int) {a}
    func foo(a: Int) {a}
}

main() {
  
}

// ASSERT: scan "DiagKind": "sema_overload_conflicts",
// ASSERT: scan "Errors": 1,
