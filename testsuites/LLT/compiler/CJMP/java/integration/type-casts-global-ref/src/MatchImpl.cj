// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import java.lang.*

@Java
public class MatchImpl {
    public func boo(): Unit {
        let a = A()
        let casted: M = match (a) {
            case _: M => a
            case _ => Option<A>.None
        }.getOrThrow()
        casted.foo()
    }
}
