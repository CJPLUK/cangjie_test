// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A non-tail exclave whose block type differs from the other branch: its type takes part in the
// if type and, when no return type is written, in the inferred return type. An unannotated
// function cannot return a non copy @local! value, so the two variants below (no return type
// annotation / explicit return type annotation) must both be rejected.

// ERRCHECK: %compiler %local %cmp_opt %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func makeC(): C @local! {
    exclave { C() }
}

func noAnnot(c: C @local!, x: Bool) {
    if (x) {
        exclave { makeC() }
    } else {
        1
    }
}

func annotated(c: C @local!, x: Bool): Any {
    if (x) {
        exclave { makeC() }
    } else {
        1
    }
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_internal_local_return",
// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
