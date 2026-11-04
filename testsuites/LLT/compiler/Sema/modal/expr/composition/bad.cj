// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json --error-count-limit=all %f -o %output 2>&1 | compare %f

class Box {
    var n: Int64
    init(n: Int64) { this.n = n }
    exclave init(this @local!, n: Int64) { this.n = n }
}

class A {
    init() {}
    exclave init(this @local!) {}
}

func f(x: Int64): Int64 {
    let a = A() @local!
    if (a is A) { 1 } else { x }
}

main() {
    let err = Box(1) @local!
    err ~> err
    var g = f ~> {
        a: Int64 =>
        A()
        a
    }
    g(0)
}

// ASSERT: scan-1 "DiagKind": "sema_invalid_binary_expr",
// ASSERT: scan "Errors": 1,
