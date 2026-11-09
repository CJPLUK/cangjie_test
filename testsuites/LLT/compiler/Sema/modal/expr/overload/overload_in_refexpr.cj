// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output -Woff all
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    var s: String
    init(this @local!) { exclave { s = "hello" } }
    init() {
        s = "hello"
    }

    prop str: String {
        get() { s }
    }
    prop str: String @local! {
        get() {
            exclave {
                s
            }
        }
    }

    func foo(this @local!) {
        exclave { str }
    }
}

main() {
    let c = C()@local!
    c.s = "bbb"
    c.foo()
    0
}