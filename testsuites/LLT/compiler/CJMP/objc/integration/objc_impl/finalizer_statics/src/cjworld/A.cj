// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*
import std.runtime.*

@ObjC
public class A <: M {
    public var tag: Int64

    public static var count: Int64 = 0
    public static var weight: Int64 = 0

    private static let mark: Int64 = 100
    private static const STEP: Int64 = 7

    private static func note(): Unit {
        count += 1
    }

    public init() {
        tag = STEP
        println("cj: A(), tag=${tag}, mark=${A.mark}")
    }

    public func touchStatics(): Unit {
        note()
        weight += mark + STEP
        println("cj: A.touchStatics(), count=${A.count}, weight=${A.weight}")
    }

    public static func collect(): Unit {
        gc()
    }

    ~init() {
        // The finalizer is moved to the registry companion, so it has to keep reaching the static members
        // declared in the impl: a private static function, a private static let and a private const static.
        note()
        weight += mark + STEP
    }
}
