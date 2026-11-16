// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package test

import java.lang.*

@JavaMirror["test.EchoMirror"]
public open class EchoMirror {
    public var objField: ?JString

    public init()

    public open func inheritedFoo(arg0: Int64): Int64

    public open func foo(arg0: Int64): Int64

    public open func goo(arg0: ?EchoMirror): ?JString

    public open func throwJavaException(): Int64
}
