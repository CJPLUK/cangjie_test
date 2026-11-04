// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class F {
    let a = 1
    init() {}
    init(this @local?) { exclave { } }
}

func f() {
    let x: F@local? = F()
    let h = { => println(x.a) }
    let _: (()->Unit)@~local = h
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 1,
