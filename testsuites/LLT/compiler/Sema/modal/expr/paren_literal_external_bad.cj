// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class C {}

func array(p: C @local!) {
    let x: Array<C> @local! = ((([p])))
}

func arrayElement(p: C @local!) {
    let x: Array<C> @local! = [(((p)))]
}

func tuple(p: C @local!) {
    let x: (C, C) @local! = ((((p, p))))
}

func tupleElement(p: C @local!) {
    let x: (C, C) @local! = ((((p))), (((p))))
}

func boxed(p: C @local!) {
    let x: Any @local! = ((([p])))
}

func optionalTuple(p: C @local!) {
    let x: ?(C, C) @local! = ((((p, p))))
}

main() {}

// ASSERT: scan-6 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan "Errors": 6,
