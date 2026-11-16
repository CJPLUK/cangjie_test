// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

open class F {
    init() {}
    init(this @local!) { exclave { } }
}
class G <: F {
    init() {}
    init(this @local!) { exclave { } }
}

func takeFull(_: G @local!) {
    0
}

func fooMatch(a: F @local!) {
    match (a) {
        case x: G => takeFull(x)
        case _ => 0
    }
}

func fooIfLet(a: F @local!) {
    if (let x: G <- a) {
        takeFull(x)
    } else {
        0
    }
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 2,
