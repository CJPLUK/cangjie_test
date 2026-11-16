// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package mylib

public struct CCopy <: Copyable {
    public var v: Int64 = 0
    public exclave init(this @ local!) {}
}

public class Holder2 {
    public var c: CCopy
    public exclave init(this @ local!) {
        c = CCopy() @ local!
    }
}

public struct ExtendedCopy { public var v: Int64 = 1 }
extend ExtendedCopy <: Copyable {}
