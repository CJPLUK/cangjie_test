// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f --output-type=staticlib -Woff all %diag_json 2>&1

interface I {}
struct S <: I & Copyable {
    var v: Int64 = 0
    exclave init(this @ local!) {}
}

class Holder {
    var f: I
    exclave init(this @ local!) {
        f = S() @ local!
    }
}

func w2(h: Holder @ local?) {
    h.f = S() @ local!
}

main(): Int64 {
    let h = Holder() @local!
    w2(h)
    0
}


// ASSERT: scan "DiagKind": "sema_bad_local_half_ma",
// ASSERT: scan "Errors": 1,
