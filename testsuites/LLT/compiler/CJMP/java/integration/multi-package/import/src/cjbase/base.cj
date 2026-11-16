// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjbase

import java.lang.*

@Java["com.java.lib.Base"]
public open foreign class Base {
    public init()
    public open func foo(): Int64
    @ForeignName["getSelf"]
    public open func self(): JObject
}
