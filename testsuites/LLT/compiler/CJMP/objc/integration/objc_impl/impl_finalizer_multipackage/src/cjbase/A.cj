// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjbase

import objc.lang.*

@ObjC
public open foreign class M {
    public init()
}

@ObjC
public open class A <: M {
    /// Moved into `A$reg`, from where the subtype's companion inherits it.
    public var weight: Int64 = 0

    public static var collected: Int64 = 0
    public static var lastWeight: Int64 = 0

    public init() {}

    public static func note(w: Int64): Unit {
        collected += 1
        lastWeight = w
    }
}
