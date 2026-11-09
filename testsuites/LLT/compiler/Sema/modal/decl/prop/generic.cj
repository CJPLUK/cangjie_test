// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

interface My {
    prop foo: String @local!
}

exclave func foo<T>(from: T @local!): String @local! where T <: My {
    from.foo
}

struct P <: My {
    public prop foo: String @local! {
        get() {
            exclave {
                "mem"
            }
        }
    }
    exclave init(this @local!) {}
}
main() {
    foo(P() @local!)
    0
}