// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class Base {
    public init()

    @ForeignName["callFunction:andX:"]
    public func callFunction(callback: CFunc<(Int32)->Unit>, x: Int32) : Unit
}
