// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output

class D {
    var v = 1
    init() {}
    init(this @local?) { exclave { } }
}

class C {
    var d: D = D()
    init(pd: D) {
        this.d = pd
    }
    init() {
        var d1: D = D()
        this.d = d1
    }
    func assignNot() {
        var d: D = D()
        this.d = d
    }
}
class WithFinalizer {
    var d: D = D()
    ~init() {
        var d: D = D()
        this.d = d
    }
}
class TestThis {
    var d: D = D()
    func method1() {
        var nd: D@~local = D()
        this.d = nd
    }
    func method2(): D@~local {
        this.d
    }
}
main(): Int64 {
    C(D())
    C()
    0
}
