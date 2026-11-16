// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open class A <: M {
    public var shared: Int64 = 0

    public static var trace: Int64 = 0

    public init() {}

    public static func mark(): Unit {
        trace = trace * 10 + 1
    }
}
