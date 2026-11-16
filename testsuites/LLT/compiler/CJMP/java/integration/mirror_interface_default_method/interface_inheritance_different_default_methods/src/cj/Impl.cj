// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package lib1

import java.lang.*;

import dom.java.lib.I0
import c.m.I1

@Java["com.java.lib.Impl"]
public class Impl <: I1 {
    public init() {
        print("In CJ Impl: start\n", flush: true)
        print("In CJ Impl before f()\n", flush: true)
        f()
        print("In CJ Impl before g()\n", flush: true)
        g()
    }
}
