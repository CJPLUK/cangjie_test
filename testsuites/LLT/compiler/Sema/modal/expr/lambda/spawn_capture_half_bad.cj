// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit all 2>&1 | compare %f

class C {
    var field: Int64 = 1
    init() {}
    init(this @local?) { exclave {} }
    func implicit(this @local?) { spawn { field } }
    func explicit(this @local?) { spawn { this.field } }
    func paren(this @local?) { spawn { (this).field } }
    func receiver(this @local?) { spawn { let x = this; 0 } }
}
func parameter(p: C @local?) { spawn { p.field } }
func local() {
    let p: C @local? = C()
    spawn { p.field }
}
func functionRef() {
    @local? func read(): Int64 { 1 }
    spawn { read() }
}
func nested(p: C @local?) {
    spawn {
        let f = { => p.field }
        f()
    }
}
func nestedSpawn() {
    spawn {
        let p: C @local? = C()
        spawn { p.field }
        0
    }
}
main() {}

// ASSERT: scan-9 "DiagKind": "sema_cannot_access_local_var_outside_exclave",
// ASSERT: scan "Errors": 9,
