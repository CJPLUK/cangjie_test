// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1
class C {
    init() {}
    init(this @local!) {
        exclave {}
    }
    mut prop x: Int64 @local! {
        get() {
            42
        }
        set(v) {
        }
    }

    exclave func bar(this @local!) {
        let a: String = x
        println(a)
        let b: String = this.x
        println(b)
    }
}
main() {
    let c: C @local! = C()
    let b: String = c.x
    println(b)
}
// ASSERT: scan-3 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 3,
