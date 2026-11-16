// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java
public class CjExe <: Exe {

    public init() {
    }

    public func PassStringsToJava(): Unit {
        let e = Exe()
        let s = e.ReturnNull()
        println(s)
    }
}
