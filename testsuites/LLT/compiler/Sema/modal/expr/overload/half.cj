// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f

class C {
    init() {}
    init(this @local?) { exclave {} }

    func foo() {
        println("foo @~local")
    }
    func foo(this @local?) {
        println("foo @local?")
    }

    func bar() {
        foo()
    }
}

main() {
    let c = C()@~local
    c.bar()
}
// ASSERT: scan foo @~local