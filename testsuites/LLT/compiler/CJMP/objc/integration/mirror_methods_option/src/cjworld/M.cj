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

    @ForeignName["instantiateOptionF"]
    public func instantiateOptionF(): Option<F>

    @ForeignName["instantiateOptionFNil"]
    public func instantiateOptionFNil(): Option<F>

    @ForeignName["oneParamOption:"]
    public func oneParamOption(param: Option<F>): Unit
}
