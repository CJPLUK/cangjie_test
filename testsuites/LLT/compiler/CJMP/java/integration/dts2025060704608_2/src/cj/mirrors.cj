// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.I1"]
public foreign interface I1 {
    func goo(a: ?I1): Int32
    func foo(): ?I1
    static func bar(): Int32
}

@Java["com.java.lib.JavaClass"]
public open foreign class JavaClass <: I1 {
    public init()
    public open func foo(): ?I1
    public open func goo(a: ?I1): Int32
    public static func bar(): Int32
    public open func goo(): Int32
    public static func bar(a: Int32): Int32
}
