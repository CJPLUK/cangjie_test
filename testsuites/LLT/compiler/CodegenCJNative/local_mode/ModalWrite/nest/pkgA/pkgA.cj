// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package pkgA

public class D {
    public var tag = 0
    public init() {}
    public init(this @local!) { exclave {} }
}

public class Inner {
    demode public var data: D
    public init() { data = D() }
    public init(this @local!) { exclave { data = D() } }
}

public class Outer {
    demode public var inner: Inner
    public init() { inner = Inner() }
    public init(this @local!) { exclave { inner = Inner() } }
}
