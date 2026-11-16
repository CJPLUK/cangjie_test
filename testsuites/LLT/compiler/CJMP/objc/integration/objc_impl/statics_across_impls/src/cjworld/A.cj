// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public var value: Int64

    public static var counter: Int64 = 0
    public static var finalized: Int64 = 0

    private static let step: Int64 = 10

    @ForeignName["initWithValue:"]
    public init(value: Int64) {
        this.value = value
    }

    public static func bump(): Unit {
        counter += step
    }

    public static func markFinalized(): Unit {
        finalized += 1
    }
}
