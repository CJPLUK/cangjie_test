// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package cjworld

import objc.lang.*

@ObjC
public open foreign class NSNumber <: NSObject {
    @ObjCInit 
    @ForeignName["initWithLongLong:"] 
    public static func initWithLongLong(value: Int64): NSNumber
    public open func longLongValue(): Int64
}

public type NSUInteger = UInt64
