// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public open foreign class M {
    @ForeignName["initWithB:"]
    init(b: Bool)
    @ForeignName["initWithM:andB:"]
    init(m: M, b: Bool)
    @ForeignName["initWithA:andM:"]
    init(a: M, m: M)
}
