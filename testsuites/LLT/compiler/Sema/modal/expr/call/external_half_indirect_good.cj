// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

func take(s: String @local?) {}
func direct(s: String @local!) { take(s) }
func indirect(s: String @local!) {
    let f: (String @local?) -> Unit = take
    f(s)
}
struct S <: Copyable {
    public prop result: String @local! {
        get() { exclave { "value" } }
    }
}
func propertyResult(s: S @local!) {
    take(s.result)
    let f: (String @local?) -> Unit = take
    f(s.result)
}
main() {}
