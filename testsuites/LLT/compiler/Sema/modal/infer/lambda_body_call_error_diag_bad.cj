// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An erroneous call inside the body of a lambda with an unannotated parameter must report the
// concrete diagnostic (here cannot convert the literal), not a generic "parameter needs a type
// annotation". The suppressed trial-matching diagnostics are re-reported on the failure path.

// ERRCHECK: %compiler %local %cmp_opt %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func take(c: C @local!): Unit {}

func bar() {
    let f = { y => exclave { take(y); take(1) } }
    let c: C @local! = C()
    f(c)
}

main() {}

// ASSERT: scan "DiagKind": "sema_cannot_convert_literal",
// ASSERT: scan-0 "DiagKind": "sema_lambdaExpr_must_have_type_annotation",
