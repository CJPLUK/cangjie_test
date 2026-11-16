// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.Exe"]
public open foreign class Exe {
    public var strField: String

    public var nullableField: ?String

    public init()

    public open func PrintString(arg0: String): Unit

    public static func PrintStringStatic(arg0: String): Unit

    public open func AcceptNullableString(arg0: ?String): Unit

    public open func EchoString(arg0: String): String

    public open func EchoNullableString(arg0: ?String): ?String

    public open func GetStringArray(): JArray<String>

    public open func EchoStringArray(arg0: ?JArray<String>): ?JArray<String>

    public open func GetNullableStringArray(): ?JArray<?String>

    public open func EchoNullableStringArray(arg0: ?JArray<?String>): ?JArray<?String>
}
