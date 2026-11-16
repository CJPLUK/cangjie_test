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
    public func explicitThis(this @local!) { let value: String @local! = this.result; check(value) }
    public func implicitThis(this @local!) { let value: String @local! = result; check(value) }
}
func object(s: S @local!) { let value: String @local! = s.result; check(value) }
func internalReceiver() {
    let s: S @local! = S()
    let value: String @local! = s.result
    check(value)
}
func staticResult() { let value: String @local! = S.staticValue; check(value) }
func parenthesized(s: S @local!) { let value: String @local! = ((s.result)); check(value) }
func check(value: String @local!) {
    if (value.size != 5) { throw Exception("unexpected getter result") }
}
main() {
    let s: S @local! = S()
    s.explicitThis()
    s.implicitThis()
    object(s)
    internalReceiver()
    staticResult()
    parenthesized(s)
}
