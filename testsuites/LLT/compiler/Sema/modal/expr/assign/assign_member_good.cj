// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

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
    init(this @local?) {
        exclave {
            this.d = D()
            d = D()
        }
    }
}

class E {
    var f: D
    init() { f = D() }
    init(this @local!) { exclave { f = D() } }
    init(this @local?) { exclave { f = D() } }
    mut prop p: D {
        get() {f}
        set(v) { f = v }
    }
}

func testObjectFieldNotBaseReceivesNot() {
    var c: C = C()
    var d: D = D()
    c.d = d
}

func testObjectPropNotBaseReceivesNot() {
    var e: E = E()
    var d: D = D()
    e.p = d
    var _ = e.p
}

main(): Unit {
    testObjectFieldNotBaseReceivesNot()
    testObjectPropNotBaseReceivesNot()
}
