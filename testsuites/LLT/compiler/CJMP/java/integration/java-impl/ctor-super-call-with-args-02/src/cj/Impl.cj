// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

/**
 * Testing for sema type of super-args
 * Primitive: Int64
 * JavaMirror: MyObject
 * JavaImpl: Impl
 */

import java.lang.*

@Java
public class Impl <: MyObject {
    public init() {
        // Primitive argument
        super(2 + 3)
    }

    public init(value: Int64) {
        // JavaMirror argument
        super(MyObject(value))
    }

    public init(x: Int64, y: Int64) {
        // JavaImpl argument
        super(Impl(x * y))
    }
}
