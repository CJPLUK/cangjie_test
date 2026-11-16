// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class D {
    init() {}
    init(this @local!) { exclave {} }
}

class Box<T> {
    demode var value: T
    init(v: T) { value = v }
    exclave init(this @local!, v: T) { value = v }
}

class Pair<T, U> {
    demode var first: T
    demode var second: U
    init(a: T, b: U) {
        first = a
        second = b
    }
    exclave init(this @local!, a: T, b: U) {
        first = a
        second = b
    }
}

func boxOfD() {
    var b: Box<D>@local! = Box<D>(D())
    let x: D = b.value
    let _: D = x
    b.value = D()
}

func pairOfDAndInt() {
    var p: Pair<D, Int64>@local! = Pair<D, Int64>(D(), 1)
    let a: D = p.first
    let _: D = a
    p.first = D()
    let _: Int64 = p.second
}

main(): Unit {
    boxOfD()
    pairOfDAndInt()
}
