// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

class C {
    init() {}
    init(this @local!) { exclave {} }
    public func read(this @local?): Int64 { 1 }
    public mut prop count: Int64 @local? {
        get() { 1 }
        set(v) {}
    }
    public mut prop payload: String @local? {
        get() { throw Exception("not executed") }
        set(v) {}
    }
    public prop result: String @local! {
        get() { exclave { "value" } }
    }
    public func assign(this @local?) {
        count = 0
        this.count = 0
        payload = "heap"
        this.payload = "heap"
    }
}
func alias(c: C @local!) {
    let h: C @local? = c
    h.read()
    h.count
    h.count = 0
    h.payload = "heap"
}
exclave func internal(c: C @local!) {
    c.read()
    c.count
    c.count = 0
    c.payload = "heap"
    let value: String @local! = c.result
    consume(c.result)
}
struct S <: Copyable {
    public static let shared: String = "heap"
    public func read(this @local?): Int64 { 1 }
    public prop count: Int64 @local? { get() { 1 } }
    public func implicit(this @local!): Int64 { read() + count }
}
func copyable(s: S @local!) {
    s.read()
    s.count
    s.implicit()
}
func consume(s: String @local!) {}
exclave func make(): String @local! { "value" }
func callResult() {
    let value: String @local! = make()
    consume(make())
}
main() {}
