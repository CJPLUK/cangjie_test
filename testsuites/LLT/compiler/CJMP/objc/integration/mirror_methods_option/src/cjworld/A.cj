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
    public static func runFromCJ(): Unit {
        let m = M()
        let f = m.instantiateOptionF()
        f?.pingF()

        let fNil = m.instantiateOptionFNil()
        match (fNil) {
            case Some(_) => println("cj: instantiateOptionFNil ERROR")
            case None => println("cj: Got expected None from instantiateOptionFNil")
        }

        m.oneParamOption(f)
        m.oneParamOption(Option<F>.None)
    }
}
