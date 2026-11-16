// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// `demode` locks instance member field to @~local regardless of receiver modal.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class D {
    var v = 1
    init() {}
    init(this @local!) { exclave {} }
    init(this @local?) { exclave {} }
}

class C {
    demode var d: D
    init() { d = D() }
    init(this @local!) { exclave { d = D() } }
    init(this @local?) { exclave { d = D() } }
}

struct SC {
    demode var d: D
    init() { d = D() }
    init(this @local!) { exclave { d = D() } }
}

func readLockedFromLocalReceiver() {
    var c: C@local! = C()@local!
    let x: D = c.d
    let _: Int64 = x.v
}

func writeLockedFromLocalReceiver() {
    var c: C@local! = C()@local!
    var v: D = D()@~local
    c.d = v
}

func structReadLockedFromLocalReceiver() {
    var s: SC@local! = SC()@local!
    let x: D = s.d
    let _: Int64 = x.v
}

main(): Unit {
    readLockedFromLocalReceiver()
    writeLockedFromLocalReceiver()
    structReadLockedFromLocalReceiver()
}
