// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface I {}
struct S <: I & Copyable {
    init() {}
    exclave init(this @local!) {}
}
func take(x: S @local!): Unit {}
func named(x!: S @local!): Unit {}
func generic<T>(x: T @local!): Unit {}
func takeInterface(x: I @local!): Unit {}
func takeMaybe(x: I @local?): Unit {}
func reordered(a!: S @local!, b!: I @local!): Unit {}
func check(s: S @local!, i: I @local!) {
    take(s)
    named(x: s)
    let t = S() @local!
    reordered(b: t, a: s)
    let f: (S @local!) -> Unit = take
    f(s)
    generic(s)
    generic<S>(s)
    takeMaybe(s)
    takeMaybe(i)
    exclave {
        takeInterface(s)
        takeInterface(i)
    }
}
main() {
    let s = S() @local!
    check(s, s)
}
