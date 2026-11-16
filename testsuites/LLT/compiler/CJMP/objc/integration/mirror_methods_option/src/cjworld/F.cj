// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class F <: K {
    public init() {
        super()
        println("cj: F init()")
    }

    @ForeignName["pingF"]
    public func pingF() {
        println("cj: pingF called")
    }

    @ForeignName["returnOption"]
    public func returnOption(): Option<F> {
        println("cj: F.returnOption() called")
        return this
    }

    @ForeignName["optionParam"]
    public func optionParam(p: Option<F>): Unit {
        print("cj: F.optionParam() called")
        match (p) {
            case Some(_) => print(" - Some\n")
            case None => print(" - None\n")
        }
    }
}
