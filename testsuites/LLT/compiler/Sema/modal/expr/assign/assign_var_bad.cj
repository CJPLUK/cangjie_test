// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f -o %output 2>&1 | compare %f

class C {
    var a = 1
    init() {}
    init(this @local!) { exclave { a = 1 } }
    init(this @local?) { exclave { a = 1 } }
}

func testNotCannotReceiveHalf() {
    var a: C = C()
    var b: C@local? = C()
    a = b
}

func testNotCannotReceiveInternal() {
    var a: C = C()
    var b: C@local! = C()
    a = b
}

func testNotCannotReceiveExternal(p: C@local!) {
    var a: C = C()
    a = p
}

func testInternalCannotReceiveNot() {
    var a: C@local! = C()
    var b: C = C()
    a = b
}

func testInternalCannotReceiveHalf() {
    var a: C@local! = C()
    var b: C@local? = C()
    a = b
}

main() {
}

// ASSERT: scan-5 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 5,

