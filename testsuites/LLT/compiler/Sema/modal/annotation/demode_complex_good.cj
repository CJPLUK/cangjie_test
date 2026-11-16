// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class D {
    var tag = 0
    init() {}
    init(this @local!) { exclave {} }
}

open class Base {
    demode var payload: D
    init() { payload = D() }
    init(this @local!) { exclave { payload = D() } }
}

class Derived <: Base {
    demode var extra: D
    init() { extra = D() }
    init(this @local!) {
        exclave {
            extra = D()
            let _: D = extra
        }
    }
}

class Outer {
    demode var inner: Inner
    init() { inner = Inner() }
    init(this @local!) { exclave { inner = Inner() } }
}

class Inner {
    demode var data: D
    init() { data = D() }
    init(this @local!) { exclave { data = D() } }
}

func derivedLockedAccess() {
    var x: Derived@local! = Derived()@local!
    let a: D = x.payload
    let b: D = x.extra
    let _: Int64 = a.tag + b.tag
    x.payload = D()
    x.extra = D()@~local
}

func nestedLockedAccess() {
    var o: Outer@local! = Outer()@local!
    let d: D = o.inner.data
    let _: Int64 = d.tag
    o.inner.data = D()@~local
}

main(): Unit {
    derivedLockedAccess()
    nestedLockedAccess()
}
