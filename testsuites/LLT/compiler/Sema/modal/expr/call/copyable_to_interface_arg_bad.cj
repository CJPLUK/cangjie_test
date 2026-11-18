// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f --output-type=staticlib -Woff all %diag_json 2>&1

interface I {}
struct S <: I & Copyable {
    exclave init(this @local!) {}
}
enum Wrapped { Value(I) }
func take(x: I @local!): Unit {}
func named(x!: I @local!): Unit {}
func reordered(a!: S @local!, b!: I @local!): Unit {}
func generic<T>(x: T @local!): Unit {}
func check(s: S @local!) {
    take(s)
    named(x: s)
    let t = S() @local!
    reordered(b: s, a: t)
    let f: (I @local!) -> Unit = take
    f(s)
    generic<I>(s)
    let wrapped = Wrapped.Value(s)
}
main() {}

// ASSERT: scan-6 "DiagKind": "sema_external_local_arg",
// ASSERT: scan "Errors": 6,
