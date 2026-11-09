// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A lambda whose own signature does not allow exclave is diagnosed, even though an outer
// function in the same scope has a non-copy @local! parameter.

// ERRCHECK: %compiler %local %cmp_opt %f -Woff all %diag_json 2>&1

class C {
    init() {}
    init(this @local!) { exclave {} }
}

func outer(c: C @local!) {
    let f = { => exclave { () } }
    f()
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_exclave_invalid_func_signature",
