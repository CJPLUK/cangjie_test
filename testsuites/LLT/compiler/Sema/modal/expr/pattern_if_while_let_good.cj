// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class F {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}
class G <: F {
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}

func foo(a: F@local!): Int {
    exclave {
        if (let x: G <- a) {
            1
        } else {
            0
        }
    }
}

func bar(a: F@local!): Int {
    exclave {
        var n = 0
        while (let x: G <- a) {
            n += 1
            break
        }
        n
    }
}

main(): Int {
    foo(G() @local!)
    bar(G() @local!)
    0
}
