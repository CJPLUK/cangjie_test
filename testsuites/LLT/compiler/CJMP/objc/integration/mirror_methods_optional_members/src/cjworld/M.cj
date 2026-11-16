// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

type PrimitiveType = Float64

@ObjC
foreign interface K {
    @ObjCOptional
    func unimplemented(): Unit
    @ObjCOptional
    func implemented(): Unit
    @ObjCOptional
    func unimplementedWithArg(i: Int64): Unit
    @ObjCOptional
    func implementedWithArg(i: Int64): Unit
}

@ObjC
public open foreign class M <: K {
    @ForeignName["init"]
    public init()

    public func implemented(): Unit
    public func implementedWithArg(i: Int64): Unit
}
