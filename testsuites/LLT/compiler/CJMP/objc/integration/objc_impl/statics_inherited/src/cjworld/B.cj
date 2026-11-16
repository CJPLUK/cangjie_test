// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class B <: A {
    public init() {
        super()
    }

    /// Redefines the base's static, so naming a class has to keep picking the one that was named.
    public redef static func mark(): Unit {
        trace = trace * 10 + 2
    }

    public static func run(): Int64 {
        A.mark()
        B.mark()
        mark()

        trace
    }

    /// An instance field the base moved into `A$reg`
    public func bumpShared(): Int64 {
        this.shared += 1
        shared
    }
}
