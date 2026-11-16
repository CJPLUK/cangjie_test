// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package cjworld

import objc.lang.*

public type NSErrorDomain = NSString

@ObjC
public open foreign class NSError <: NSObject {
    public open func code(): NSInteger
    public open func domain(): NSErrorDomain
}
