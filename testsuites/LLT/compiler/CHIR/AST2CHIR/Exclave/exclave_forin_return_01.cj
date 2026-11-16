// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %n.cj -Woff unused -o %output
// RUN-EXEC-PIPE-0: %run %run_opt %output

class C {
    var x: Int
    init(this @ ~local, v: Int64) {
        x = v
    }
    exclave init(this @ local!, v: Int64) {
        x = v
    }
}

func pick(xs: Array<Int64>): C@local! {
    for (i in xs) {
        if (i > 0) {
            exclave { C(i) }
        }
    }
    exclave { C(-1) }
}

main() {
    if (pick([0, 0, 5, 9]).x != 5) {
        println("error 1")
        return -1
    }
    if (pick([0, -1]).x != -1) {
        println("error 2")
        return -2
    }
    0
}
