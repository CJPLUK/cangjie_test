// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_var

public func acceptCopyFull(a: Int64 @local!): Int64 {
    a
}

public let acceptsLocal: (Int64 @local!) -> Int64 = acceptCopyFull

public func normal(a: Int64): Int64 {
    a
}

public let normalVar: (Int64) -> Int64 = normal

public let junk: ((Int64 @local!) -> Int64) -> Int64 = { a => 0 }
