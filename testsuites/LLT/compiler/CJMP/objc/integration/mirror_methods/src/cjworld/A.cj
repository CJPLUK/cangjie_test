// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: M {
    public init() {
        super()
    }

    @ForeignName["runFromCJ"]
    public static func runFromCJ() {
        let m = M()

        let k = m.noParams()
        println("cj: runFromCJ k.number ${k.number}")

        let f = m.oneParam(987)
        println("cj: runFromCJ f.numberPlusOne ${f.numberPlusOne()}")

        M.staticFunc(42)
        m.openFunc(42)

        // Doesn't work with more than one argument for now
        // m.twoParams(123, 3.1415)
        // m.fiveParams(1, 2, 3, 4, 5)
    }

    public override func openFunc(first: Int64): Unit {
        println("cj: openFunc override ${first}")
    }
}
