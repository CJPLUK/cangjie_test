// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

/**
 * Testing expr kind of super arg
 * Sema type: Int64
 * Expr kind:
 *     literalConst
 *     binaryExpr
 *     global var
 *     global func call
 *     parameter of constructor
 */

import java.lang.*

var gv: Int64 = 1

func gf(x: Int64): Int64 {
    x + 1
}

@Java
public class Impl <: MyObject {
    public init() {
        super(1)
    }

    public init(value: Int64) {
        super(value + 1)
    }

    public init(x: Int64, y: Int64) {
        super(y + x)
    }

    public init(x: Int64, y: Int64, z: Int64) {
        super(y + x + gv + gf(z))
    }

    public init(x: Int64, y: Int64, z: Int64, u: Int64) {
        super(if (x > y) {x} else {y} + match {
            case z > u => u
            case u > z => z
            case _ => u
        })
    }
}
