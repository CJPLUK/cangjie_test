// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_func

public class NC {
    public init() {}
    public init(this @local!) { exclave {} }
}

public func takeCopyFull(a: Int64 @local!): Int64 {
    1
}

public func takeCopyHalf(a: Int64 @local?): Int64 {
    1
}

public func takeObjFull(a: NC @local!): Int64 {
    1
}

public func takeObjHalf(a: NC @local?): Int64 {
    1
}

public func takeNested(f: (Int64 @local!) -> Int64): Int64 {
    1
}

public exclave func retObjFull(): NC @local! {
    NC()
}

public exclave func retObjHalf(): NC @local? {
    NC()
}

public func normal(a: Int64): Int64 {
    a
}
