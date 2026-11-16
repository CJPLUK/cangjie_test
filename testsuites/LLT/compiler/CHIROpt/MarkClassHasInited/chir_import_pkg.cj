// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Shared package source for MarkClassHasInited import IR cases.

package pkg

public class Handle {
    public var x: Int64 = 0
    public init() {
    }
    ~init() {
        println(x)
    }
}

public class Plain {
    public var y: Int64 = 0
    public init() {
    }
}
