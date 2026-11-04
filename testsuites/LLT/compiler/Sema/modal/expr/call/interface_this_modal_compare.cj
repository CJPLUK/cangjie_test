// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

interface I1 {
    func foo(this @local!): Unit
}
interface I2 {
    func foo(this @local?): Unit
}
interface I3 <: I1 & I2 {}

class C <: I3 {
    public func foo(this @local!): Unit {}
    public func foo(this @local?): Unit {}
}

func test(v: I3 @local?) {
    v.foo()
}

main() {}
