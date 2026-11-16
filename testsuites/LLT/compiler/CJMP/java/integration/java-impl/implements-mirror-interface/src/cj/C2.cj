// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.JObject

@Java["com.java.lib.C2"]
public class C2 <: I2 & I3 {
    public init() {
        println("in CangjieInvoke Init")
    }

    public func test() {
        println("in CangjieInvoke Func")
        return false
    }
}
