// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json --error-count-limit=all %f -o %output 2>&1 | compare %f

class D {
    var v = 1
    init() {}
    init(this @local!) { exclave {} }
    init(this @local?) { exclave {} }
}

class C {
    var d: D
    init() { d = D()}
    init(this @local!) { exclave { d = D() } }
    init(this @local?) { exclave { d = D() } }

    func badAssignHalf() {
        var d: D@local? = D()
        this.d = d
    }

    func badAssignInternal() {
        var d: D@local! = D()
        this.d = d
    }

    func badAssignExternal(pd: D@local!) {
        this.d = pd
    }
}

class TestMemberAssign {
    var d: D
    init() { d = D()}
    init(this @local!) { exclave { d = D() } }
    init(this @local?) { exclave { d = D() } }

    func badAssignToLocalHalf() {
        var c: C@local? = C()
        var nd: D@local? = D()
        c.d = nd
    }

    func badAssignToLocalFull() {
        var c: C@local! = C()
        var nd: D@local! = D()
        c.d = nd
    }
}

main() {
}

// ASSERT: scan-1 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan-3 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 4,
