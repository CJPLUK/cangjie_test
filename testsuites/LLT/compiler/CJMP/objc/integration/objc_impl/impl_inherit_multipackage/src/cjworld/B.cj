// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*
import cjbase.*

/// `B$reg` has its super class restored to the imported `A$reg`, the one case where the parent companion is
/// looked up through the import manager instead of the in-package map. Everything the base moved into its own
/// companion is named here without a qualifier, which is what reaches it through the imported proxies.
@ObjC
public class B <: A {
    /// Reads the imported base's static state from a field initializer, which runs inside `B$reg`.
    public var stamp: Int64 = trace

    public init() {
        super()
    }

    /// Redefines the imported base's static, so naming a class has to keep picking the one that was named.
    public redef static func mark(): Unit {
        trace = trace * 10 + 2
    }

    /// Overrides an imported `@ObjC` method and reaches the overridden one through the restored parent.
    public func tag(): Int64 {
        super.tag() * 10 + 2
    }

    /// An instance field the imported base moved into `A$reg`.
    public func bumpShared(): Int64 {
        this.shared += 1
        shared
    }

    public func stampValue(): Int64 {
        stamp
    }

    public static func run(): Int64 {
        A.mark()
        B.mark()
        mark()

        trace
    }
}
