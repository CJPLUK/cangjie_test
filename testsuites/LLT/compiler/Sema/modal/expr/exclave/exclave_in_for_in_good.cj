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

func closedRange(a: P @ local!): Int64 {
    for (_ in 0..=3) {
        exclave { a.age }
    }
    return 0
}

func openRange(a: P @ local!): Int64 {
    for (_ in 0..3) {
        exclave { a.age }
    }
    return 0
}

func stringIter(a: P @ local!): Int64 {
    for (c in "ab") {
        exclave { a.age + Int64(c) }
    }
    return 0
}

func iteratorIter(a: P @ local!): Int64 {
    for (x in [1, 2].iterator()) {
        exclave { a.age + x }
    }
    return 0
}

main(): Int64 {
    let p = P(1) @ local!
    closedRange(p)
    openRange(p)
    stringIter(p)
    iteratorIter(p)
    0
}
