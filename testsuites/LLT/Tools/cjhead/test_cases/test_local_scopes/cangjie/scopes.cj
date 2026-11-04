// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_scopes

public interface Actions {
    func run(): Unit
    func run(this @local?): Unit {}
    prop size: Int64
    prop size: Int64 @local? { get() { 0 } }
}
public open class Parent {
    protected func keep(x!: Int64 = 3): Unit {}
    protected func localOnly(this @local?): Unit {}
}
public struct Value {
    public func member(): Unit {}
    public func member(this @local?): Unit {}
}
extend Value {
    public func extra(): Unit {}
    public func extra(this @local?): Unit {}
}
public enum Kind {
    Plain
    public func member(): Unit {}
    public func member(this @local?): Unit {}
}

main() {}
