// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC
public class A <: K {
    public init() {
        super()
    }

    public func getNumber(): Int32 {
        return 42
    }

    @ForeignName["runFromCJ"]
    public func runFromCJ() {
        println("cj: runFromCJ super.getNumber ${super.getNumber()}")
    }
}
