// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cj

import java.lang.*

@Java["com.java.lib.MyObject"]
public open foreign class MyObject {
    public init()
    public open func foo(): Unit
    public open func bar(): Int32
    public open func foo(a: Int32): Int32
    public open func foo(a: JString): JString
    public open func foo(a: ?MyObject): ?MyObject

    public open func testValue(): Int64
}
