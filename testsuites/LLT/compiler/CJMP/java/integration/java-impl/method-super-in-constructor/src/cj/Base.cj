// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java["com.java.lib.Base"]
open foreign class Base <: JObject {
    public init()
    public open func bar(): Bool
    public open func foo(i: Int64): Int64
}
