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
public class A <: M {
    public var value: Int64 = 3

    public static var trace: Int64 = 0

    public init() {}

    public static func mark(): Unit {
        trace = trace * 10 + 1
    }
}
