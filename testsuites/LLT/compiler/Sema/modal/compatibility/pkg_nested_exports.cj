// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_nested_exports
public func full(x: Int64 @local!): Int64 { x }
public func half(x: Int64 @local?): Int64 { x }
public func plain(x: Int64): Int64 { x }
public class Exports {
    public static let fullCallback: (Int64 @local!) -> Int64 = full
    public static let halfCallback: (Int64 @local?) -> Int64 = half
    public static let plainCallback: (Int64) -> Int64 = plain
}
public func makeFull(): (Int64 @local!) -> Int64 { full }
public func makeHalf(): (Int64 @local?) -> Int64 { half }
public func makePlain(): (Int64) -> Int64 { plain }
