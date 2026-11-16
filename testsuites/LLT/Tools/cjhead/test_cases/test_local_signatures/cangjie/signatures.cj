// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_signatures

public class Item {
    public demode let data: String = "data"
    public init() {}
    public exclave init(this @local!) {}

    // KEEP: ordinary API with local implementation
    @Deprecated[message: "kept annotation"]
    public func ordinary(x!: Int64 = 7): Int64 {
        @local? func nested(): Unit {}
        let localItem: Item @local! = Item() @local!
        let temporary: String @local! = "temporary"
        x
    }
    public func echo(value: String): String { value }
    public exclave func echo(this @local!, value: String @local!): String @local! { value }
    public func borrowed(this @local?): Unit {}
    public func explicitNot(this @~local, value: String @~local): String @~local { value }
    public prop size: Int64 { get() { 1 } }
    public prop size: Int64 @local? { get() { 1 } }
}

public func local(): Int64 { 1 }
public func make(): String { "ordinary" }
public exclave func make(value: String @local!): String @local! { value }
public func onlyLocal(value: String @local?): Unit {}

main() {}
