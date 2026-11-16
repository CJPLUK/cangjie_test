// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java["com.java.lib.MyObject"]
open foreign class MyObject <: JObject {
    public init()

    public static func check(): Int32
    public static func self(): MyObject
    public func value(): Int32 // extra non-static value
}
