// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %n.cj -Woff unused -o %output
// RUN-EXEC-PIPE-0: %run %run_opt %output 2>&1 | compare %f
// ASSERT: scan-2 7

class C {
    init() {
        x = 3
    }
    exclave init(this @local!) {
        x = 7
    }
    var x: Int
}

func make(flag: Bool): C@local! {
    if (flag) {
        let b = exclave { C() }
        return b
    }
    exclave { C() }
}

main() {
    println(make(true).x)
    println(make(false).x)
}
