// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

open class Base {
    var a = 1
    init(this @local?) { exclave { } }
}

class Derived <: Base {
    init(this @local?) { exclave { } }

    func bar(this @local?) {
        let h = { => println(super.a) }
        let _: ()->Unit = h
    }
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 1,
