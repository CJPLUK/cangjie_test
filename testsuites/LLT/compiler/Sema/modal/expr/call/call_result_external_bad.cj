// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class Holder {
    var value: String
    exclave init(this @local!, value: String @local!) { this.value = value }
}
struct S <: Copyable {
    init(this @local!) { exclave {} }
    prop result: String @local! { get() { exclave { "value" } } }
}
func make(): String @local! { exclave { "value" } }
func assignCall(h: Holder @local!) { h.value = make() }
func assignProperty(h: Holder @local!, s: S @local!) { h.value = s.result }
func fieldResult(h: Holder @local!) { let value: String @local! = h.value }
func returnCall(): String @local! { make() }
func returnProperty(s: S @local!): String @local! { s.result }
main() {}

// ASSERT: scan-3 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan-2 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 5,
