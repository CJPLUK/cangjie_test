// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class D {
    var v = 0
    init() {}
    init(this @local!) { exclave {} }
    init(this @local?) { exclave {} }
}

class C {
    demode var d: D
    init() { d = D() }
    init(this @local!) {
        exclave {
            d = D()
            let check: D = d
            let _: Int64 = check.v
        }
    }
    init(this @local?) {
        exclave {
            d = D()
            let check: D = d
        }
    }

    func readImplicit(this @local!): D {
        exclave {
            d
        }
    }

    func writeImplicit(this @local!) {
        exclave {
            var v: D = D()
            d = v
        }
    }
}

func useImplicitThis() {
    var c: C@local! = C()@local!
    let got: D = c.readImplicit()
    let _: Int64 = got.v
    c.writeImplicit()
}

main(): Unit {
    useImplicitThis()
}
