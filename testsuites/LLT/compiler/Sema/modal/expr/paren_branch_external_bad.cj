// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

class D { init(this @local!) { exclave {} } }
class C {
    var field: D
    init(this @local!) { exclave { field = D() @local! } }
}

func ifBranch(p: C @local!) {
    let result = (((if (true) { (((p))) } else { (((p))) })))
    match (result) {
        case b => b.field = D() @local!
    }
}

func matchBranch(p: C @local!) {
    let result = (((match (0) { case _ => (((p))) })))
    match (result) {
        case b => b.field = D() @local!
    }
}

func tryBranch(p: C @local!) {
    let result = (((try { (((p))) } finally {})))
    match (result) {
        case b => b.field = D() @local!
    }
}

main() {}

// ASSERT: scan-3 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan "Errors": 3,
