// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test.local_signatures
public class Item {
    public let data: String = "data"
    public init()
    // KEEP: ordinary API with local implementation
    @Deprecated[message: "kept annotation"]
    public func ordinary(x!: Int64 = 7): Int64
    public func echo(value: String): String
    public func explicitNot(value: String): String
    public prop size: Int64
}
public func local(): Int64
public func make(): String
