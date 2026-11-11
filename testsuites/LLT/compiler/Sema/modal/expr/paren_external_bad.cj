// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class D { init(this @local!) { exclave {} } }

struct S { var v: Int64 = 0 }

class C {
    var field: D
    init(this @local!) { exclave { field = D() @local! } }
    func touch(this @local!) {}
}

func consume(_: C @local!) {}
func consume(_: D @local!) {}
func consume(_: S @local!) {}

func argument(p: C @local!) {
    consume((((p))))
}

func memberArgument(p: C @local!) {
    consume((((p.field))))
}

func receiver(p: C @local!) {
    (((p))).touch()
}

func initializer(p: C @local!) {
    let x: C @local! = (((p)))
}

func assignment(p: C @local!) {
    var x = C() @local!
    x = (((p)))
}

func memberAssignment(p: D @local!) {
    let holder = C() @local!
    holder.field = (((p)))
}

func elementArgument(p: VArray<S, $1> @local!) {
    consume((((p[0]))))
}

main() {}

// ASSERT: scan-4 "DiagKind": "sema_external_local_arg",
// ASSERT: scan-3 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan "Errors": 7,
