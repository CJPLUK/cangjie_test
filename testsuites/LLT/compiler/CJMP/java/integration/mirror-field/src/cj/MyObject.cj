// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java["com.java.lib.MyObject"]
public open foreign class MyObject <: JObject {
    public var obj: JObject
    public static var sobj: JObject
    public init(a:Int16)
    public var x: Bool
    public let y: Int16
    public static var sx: Int32
    public static let sy: Int64
}
