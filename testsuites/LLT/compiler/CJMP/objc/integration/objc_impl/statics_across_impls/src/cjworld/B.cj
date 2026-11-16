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

    /**
     * A static function moves into `B$reg`
     */
    @ForeignName["readThrough"]
    public static func readThrough(): Int64 {
        let a = A(7)

        A.bump()
        bumpTwice()

        A.counter + a.value
    }

    private static func bumpTwice(): Unit {
        A.bump()
        A.bump()
    }

    /// An instance method stays behind in the impl and reaches the same statics through the proxies there.
    public func tag(): Int64 {
        A.counter
    }

    @ForeignName["collect"]
    public static func collect(): Unit {
        gc()
    }

    ~init() {
        // The finalizer moves into `B$reg` too
        A.markFinalized()
    }
}
