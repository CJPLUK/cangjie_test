// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_scopes
public interface Actions {
    func run(): Unit
    prop size: Int64
}
public open class Parent {
    protected func keep(x!: Int64 = 3): Unit
}
public struct Value {
    public func member(): Unit
}
extend Value {
    public func extra(): Unit
}
public enum Kind {
    Plain
    public func member(): Unit
}
