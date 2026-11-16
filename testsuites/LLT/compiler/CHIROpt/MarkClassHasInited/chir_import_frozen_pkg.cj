// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Upstream package: `@Frozen` finalizer so the body is re-imported by
// downstream packages (requires -O2).

package pkg

public class Handle {
    public var x: Int64 = 0
    public init() {
    }
    @Frozen
    ~init() {
        println(x)
    }
}
