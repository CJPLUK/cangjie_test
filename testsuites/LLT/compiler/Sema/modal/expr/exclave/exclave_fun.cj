// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    init() {}
    exclave init(this @local!) {}

    exclave func foo() {
        C()@local!
    }
    static exclave unsafe func bar() {
        C()@local!
    }
}
exclave func foo(): C @local! {
    C()
}
enum E {
    | A
    exclave func foo(this @local!) {
        
    }
}

main() {
    let c = foo()
}
