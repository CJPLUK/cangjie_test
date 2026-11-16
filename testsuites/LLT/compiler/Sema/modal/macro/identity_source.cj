// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: identity.macro.cj
// EXEC: %compiler %local %cmp_macro identity.macro.cj
// EXEC: %run_macro %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import identity_macro.*

@Identity
class Box {
    demode var tag: String = "t"
    init() {}
    exclave init(this @local!) {}
    exclave func take(this @local!, s: String @local!): String @local! { s }
    func half(this @local?): Int64 { 1 }
    func notLocal(this @~local): Int64 { 0 }
    static exclave func make(): Box @local! { Box() @local! }
}

@Identity
struct Pair {
    exclave init(this @local!) {}
    func f(this @local!): Unit {}
}

@Identity
enum Color {
    | Red
    | Blue
    func name(this @local?): String { "c" }
}

@Identity
exclave func echo(s: String @local!): String @local! { s }

@Identity
func nestedLocal(x: String @local!): Unit {
    @local? func goo(y: String @local!): Unit { exclave { if (y.size >= 0) {} } }
    exclave { goo(x) }
}

@Identity
func take(local!: Int64): Int64 {
    local
}

main() {
    let raw = Box()
    let m = raw.notLocal()
    let b = Box.make()
    let s = b.take("hi")
    let n = b.half()
    let e = echo("ok")
    let p = Pair() @local!
    p.f()
    let name = Color.Red.name()
    nestedLocal(e)
    let k = take(local: 1)
    if (s.size + n + e.size + name.size + k + m > 0) {
        println("ok")
    }
}
