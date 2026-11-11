// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit all 2>&1 | compare %f

class C {
    var field: Int64 = 1
    init(this @local!) { exclave {} }
    func implicit(this @local!) { spawn { field } }
    func explicit(this @local!) { spawn { this.field } }
    func paren(this @local!) { spawn { (this).field } }
}
func parameter(p: C @local!) { spawn { p.field } }
func local() {
    let p = C() @local!
    spawn { p.field }
}
main() {}

// ASSERT: scan-5 "DiagKind": "sema_bad_capture_local",
// ASSERT: scan "Errors": 5,
