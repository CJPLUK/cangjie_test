// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class P {
    var age: Int64
    init(this @ local!, a: Int64) {
        exclave { this.age = a }
    }
}

func makeIter(n: Int64): Iterator<Int64> {
    match (n) {
        case 0 => [0].iterator()
        case _ => [n, n + 1].iterator()
    }
}

func rangeEndExpr(a: P @ local!): Int64 {
    for (i in 0..(exclave { a.age + 3 })) {
        println(i)
    }
    return 0
}

func rangeStartExpr(a: P @ local!): Int64 {
    for (i in (exclave { a.age + 1 })..5) {
        println(i)
    }
    return 0
}

func closedStepExpr(a: P @ local!): Int64 {
    for (i in 0..=10 : exclave { a.age + 2 }) {
        println(i)
    }
    return 0
}

func openStepExpr(a: P @ local!): Int64 {
    for (i in 0..10 : exclave { a.age + 1 }) {
        println(i)
    }
    return 0
}

func stringExpr(a: P @ local!): String {
    for (c in "ab" + exclave { a.age.toString() }) {
        println(c)
    }
    return ""
}

func iteratorExpr(a: P @ local!): Int64 {
    for (x in makeIter(exclave { a.age + 4 })) {
        println(x)
    }
    return 0
}

main(): Int64 {
    let p = P(1) @ local!
    if (rangeEndExpr(p) != 4) {
        return 1
    }
    if (rangeStartExpr(p) != 2) {
        return 2
    }
    if (closedStepExpr(p) != 3) {
        return 3
    }
    if (openStepExpr(p) != 2) {
        return 4
    }
    if (stringExpr(p) != "1") {
        return 5
    }
    if (iteratorExpr(p) != 5) {
        return 6
    }
    0
}
