// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class F {
    var p = 1
    init() {}
    init(this @local!) { exclave { } }
    init(this @local?) { exclave { } }
}
func bar(a: F@local!): F@local! {
    exclave {
        var g: F@local! = a
        g.p = a.p + 1
        g
    }
}

func foo(a: F@local!): F@local! {
    exclave {
        bar(a)
    }
}

main() {
    let h: F@local! = F()
    bar(h).p - foo(h).p + 1
}
