// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject
import abstract.Abstract

@Java["com.java.lib.Child"]
open foreign class Child <: Abstract {
    public init()
    public func foo(): Abstract
}
