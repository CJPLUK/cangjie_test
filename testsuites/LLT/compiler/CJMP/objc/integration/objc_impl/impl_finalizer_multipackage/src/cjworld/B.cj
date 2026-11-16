// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*
import cjbase.*
import std.runtime.*

@ObjC
public class B <: A {
    public init() {
        super()
    }

    /// Writes the imported base's field from the impl, where it is reached through the base's proxy.
    public func charge(amount: Int64): Unit {
        weight = amount
    }

    public static func collect(): Unit {
        gc()
    }

    ~init() {
        // The finalizer is moved to `B$reg`, so the imported base's members have to be reached the way the
        // companions hold them: `weight` inherited from `A$reg`, `note` moved there along with the statics it
        // writes. A field of a supertype is readable in a finalizer, and staying a field is what keeps it so.
        weight += 1
        note(weight)
    }
}
