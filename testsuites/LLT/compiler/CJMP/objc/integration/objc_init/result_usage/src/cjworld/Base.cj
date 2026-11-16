// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class Base {
    public var x: Int32

    public init()

    public init(bool: Int32)

    @ObjCInit
    @ForeignName["initWithB:"]
    public static func initWithBool(bool: Int32): Base

    @ForeignName["baseTest"]
    public func baseTest(): Unit
}
