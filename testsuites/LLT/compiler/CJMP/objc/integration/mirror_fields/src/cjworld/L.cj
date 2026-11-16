// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class L <: K {
    public L() {
        version = 0
        println("cj: L()")
    }

    @ForeignName["initWithVersion:"]
    public init(versionArg: Int64) {
        version = versionArg
        println("cj: L() init with version, version: ${versionArg}")
    }

    @ForeignName["bar"]
    public func bar() {
        println("cj: L.bar()")
    }
}
