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
    init() { d = D() }
    init(this @local!) { exclave { d = D() } }
    init(this @local?) { exclave { d = D()@local? } }

    func assignThisDotBad(this @local?) {
        var x: D@local? = D()
        this.d = x
    }

    func assignImplicitThisBad(this @local?) {
        var x: D@local? = D()@local?
        d = x
    }
}

class E {
    var f: D
    init() { f = D() }
    init(this @local!) { exclave { f = D() } }
    mut prop p: D {
        get() {f }
        set(v) { f = v }
    }
}

func testObjectFieldNotBaseReceiveHalf() {
    var c: C = C()
    var d: D@local? = D()@local?
    c.d = d
}

func testObjectFieldNotBaseReceiveInternal() {
    var c: C = C()
    var d: D@local! = D()
    c.d = d
}

func testObjectFieldNotBaseReceiveExternal(p: D@local!) {
    var c: C = C()
    c.d = p
}

func testObjectFieldInternalBaseReceiveHalf() {
    var c: C@local! = C()
    var d: D@local? = D()@local?
    c.d = d
}

func testObjectFieldExternalBaseReceiveInternal(pc: C@local!) {
    var d: D@local! = D()
    pc.d = d
}

func testObjectFieldExternalBaseReceiveHalf(pc: C@local!) {
    var d: D@local? = D()
    pc.d = d
}

func testObjectPropNotBaseReceiveHalf() {
    var e: E = E()
    var d: D@local? = D()@local?
    e.p = d
}

func testObjectPropNotBaseReceiveInternal() {
    var e: E = E()
    var d: D@local! = D()
    e.p = d
}

func testObjectPropInternalBaseReceiveHalf() {
    var e: E@local! = E()
    var d: D@local? = D()@local?
    e.p = d
}

main() {
}

// ASSERT: scan-1 "DiagKind": "sema_no_match_prop_accessor_for_call",
// ASSERT: scan-1 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-2 "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan-7 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 11,
