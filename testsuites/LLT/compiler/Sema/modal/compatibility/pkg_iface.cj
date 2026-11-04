// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package pkg_iface

public class NC {
    public init() {}
}

public interface IParam {
    func f(a: Int64 @local!): Unit
}

public interface IRet {
    func f(): NC @local!
}

public interface IThis {
    func f(this @local!): Unit
}
