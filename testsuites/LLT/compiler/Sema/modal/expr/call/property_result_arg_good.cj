// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct S <: Copyable {
    init(this @local!) { exclave {} }
    public prop result: String @local! {
        get() { exclave { "value" } }
    }
    public static prop staticValue: String @local! {
        get() { exclave { "value" } }
    }
    public func explicitThis(this @local!) { accept(this.result) }
    public func implicitThis(this @local!) { accept(result) }
}
func object(s: S @local!) { accept(s.result) }
func internalReceiver() {
    let s: S @local! = S()
    accept(s.result)
}
func staticResult() { accept(S.staticValue) }
func parenthesized(s: S @local!) { accept(((s.result))) }
func accept(s: String @local!) {
    if (s.size != 5) { throw Exception("unexpected call result") }
}
func make(): String @local! { exclave { "value" } }
func callResult() {
    let value: String @local! = make()
    accept(value)
    accept(make())
}
main() {
    let s: S @local! = S()
    s.explicitThis()
    s.implicitThis()
    object(s)
    internalReceiver()
    staticResult()
    parenthesized(s)
    callResult()
}
