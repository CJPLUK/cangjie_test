// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

macro package identity_local_macro

internal import std.ast.*

func tryRoundTrip(code: String): Unit {
    try {
        let _ = parseDecl(cangjieLex(code)).toTokens()
    } catch (_: Exception) {
        ()
    }
}

// Parse-round-trip local-mode surfaces, then emit a runnable subset.
public macro Identity(input: Tokens): Tokens {
    tryRoundTrip(
        """
class Box {
    demode var tag: String = "box"
    init(this @~local) {}
    exclave init(this @local!) {}
    exclave init(this @local?, s: String @local?) {}
    exclave func take(this @local!, s: String @local!): String @local! { s }
    func half(this @local?): Int64 { 1 }
    func notLocal(this @~local): Int64 { 0 }
    static exclave func make(): Box @local! { Box() @local! }
    prop p: Int64 @local! { get() { 7 } }
}
""")
    tryRoundTrip(
        """
struct Pair {
    exclave init(this @local!) {}
    func f(this @local!): Unit {}
}
""")
    tryRoundTrip(
        """
enum Color {
    | Red
    | Blue
    func name(this @local?): String { "c" }
}
""")
    tryRoundTrip("exclave func echo(s: String @local!): String @local! { s }")
    tryRoundTrip(
        """
func nestedLocal(x: String @local!): Unit {
    @local? func goo(y: String @local!): Unit { exclave {} }
    exclave { goo(x) }
}
""")

    cangjieLex(
        """
class Box {
    demode var tag: String = "t"
    exclave init(this @local!) {}
    exclave func take(this @local!, s: String @local!): String @local! { s }
    func half(this @local?): Int64 { 1 }
    static exclave func make(): Box @local! { Box() @local! }
}
exclave func echo(s: String @local!): String @local! { s }
""")
}
