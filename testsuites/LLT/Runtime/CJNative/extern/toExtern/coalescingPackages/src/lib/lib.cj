// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package lib

import std.collection.*

public class RT <: ForeignRuntime<RT> {
    public static func memberAccess(e: Extern<RT>, field: String): Extern<RT> { e }
    public static func indexedAccess(e: Extern<RT>, arg: Any): Extern<RT> { e }
    public static func memberUpdate(e: Extern<RT>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<RT>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { e }
    public static func fromExtern<R>(e: Extern<RT>): R { (Extern<RT>.getPayload(e) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<RT> {
        conversions++
        Extern<RT>(v)
    }
    public static var conversions = 0
}

public func coalesce<R>(o: ?Extern<R>, x: Int64): Extern<R> where R <: ForeignRuntime<R> {
    o ?? x
}

public func coalesceAny<R, U>(o: ?Extern<R>, x: U): Extern<R> where R <: ForeignRuntime<R> {
    o ?? x
}

@Frozen
public func coalesceFrozen(o: ?Extern<RT>): Extern<RT> {
    o ?? 2
}

public class XBox<R> where R <: ForeignRuntime<R> {
    public XBox(public let o: ?Extern<R>) {}
    public func get(x: String): Extern<R> {
        o ?? x
    }
}
