// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

type PrimitiveType = Float64

@ObjC
public open foreign class M {
    @ForeignName["init"]
    public init()

    @ForeignName["noParams"]
    public func noParams(): K

    @ForeignName["oneParam:"]
    public func oneParam(first: Int64): F

    @ForeignName["twoParams:b:"]
    public func twoParams(first: Int64, second: Float64): PrimitiveType

    @ForeignName["fiveParams:b:c:d:e:"]
    public func fiveParams(first: Int64, second: Int64, third: Int64, fourth: Int64, fifth: Int64): Int64

    @ForeignName["staticFunc:"]
    public static func staticFunc(first: Int64): Unit

    @ForeignName["openFunc:"]
    public open func openFunc(first: Int64): Unit
}
