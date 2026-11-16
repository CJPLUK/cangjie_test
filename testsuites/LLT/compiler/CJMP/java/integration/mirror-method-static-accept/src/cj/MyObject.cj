// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java["com.java.lib.MyObject"]
foreign class MyObject <: JObject {
    public init()

    public static func check(value: Int32): Unit
    public static func self(obj: MyObject): Unit
    public static func impl(impl: Impl): Unit
}
