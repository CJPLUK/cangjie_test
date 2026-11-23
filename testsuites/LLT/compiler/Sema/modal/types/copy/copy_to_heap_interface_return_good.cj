// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

interface I {}
struct S <: Copyable & I {}
func explicitFull(x: S @local!): I { return x }
func explicitHalf(x: S @local?): I { return x }
func implicitFull(): I {
    let x: S @local! = S()
    x
}
func implicitHalf(): I {
    let x: S @local? = S()
    x
}
func primitiveFull(x: Int64 @local!): ToString { x }
func primitiveHalf(x: Int64 @local?): ToString { x }
main() {}
