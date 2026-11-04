// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -o %output 2>&1 | compare %f

class F {
    let p: Int = 1
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}
main() {
    let a: F@local! = F()
    return a.p // local modal of Copy type is ignored
}

func foo(): F@local! {
    let b: F@local! = F()
    b
}
func bar(): F@local! {
    let c: F@local! = F()
    return c
}
func baz(): Int@local! {
    let c: F@local! = F()
    return c.p
}

// ASSERT: scan-2 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
