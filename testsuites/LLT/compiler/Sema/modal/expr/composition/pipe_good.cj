// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC-PIPE: %run %run_opt %output %run_args | compare %f

class Box {
    public var n: Int64
    init(n: Int64) { this.n = n }
    exclave init(this @local!, n: Int64) { this.n = n }
}

class C {
    static func f(): Int64 {
        0
    }
    static func f(i: Int64): Int64 {
        i
    }
}

exclave func inc(b: Box @local!): Box @local! {
    Box(b.n + 1)
}

exclave func take(ins: Box @local!): Int64 {
    ins.n
}

func neg(b: Bool): Bool {
    let box = Box(if (b) { 1 } else { 0 }) @local!
    box.n == 0
}

exclave func run(x: Box @local!): Int64 {
    let stepped = x |> inc |> inc |> inc
    stepped.n + (x |> take)
}

func pipeOr(flag: Bool): Bool {
    flag || false |> neg
}

class P {
    var p = 2
    exclave init(this @local!) {}
    exclave operator func ()(this @local!, b: Box @local!): Box @local! {
        Box(b.n + p)
    }
}
class Q {
    var q = 1
    exclave init(this @local!) {}
    exclave operator func ()(this @local?, b: Box @local!): Box @local! {
        Box(b.n - q)
    }
}

main() {
    let box = Box(1) @local!
    let piped = run(box)
    let overloaded = C.f() + (2 |> C.f)
    let negated = false |> neg
    let mixed = pipeOr(true)
    println("${piped} ${overloaded} ${negated} ${mixed}")

    let bb = Box(0) @local!
    let p = P() @local!
    let q = Q() @local!
    q.q += 10
    let pq = p(q(bb))
    println("${pq.n}")
}

/* SCAN
5 2 true false
-9
*/
