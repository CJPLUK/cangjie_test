// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*
import std.runtime.*

@ObjC
public class B <: M {
    public init() {}

    @ForeignName["take:"]
    public static func take(a: A): Int64 {
        a.value
    }

    @ForeignName["collect"]
    public static func collect(): Unit {
        gc()
    }
}
