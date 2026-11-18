// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args
// EXEC: %compiler %local %f -o %output -O2
// RUN-EXEC: %run %run_opt %output %run_args

func jumps(a: Array<Int64> @local!): Int64 {
    exclave {
        var n = 0
        for (i in 0..4) {
            if (i == 1) { continue }
            if (i == 3) { break }
            n += i
        }
        for (i in 0..=4) {
            if (i == 1) { continue }
            if (i == 3) { break }
            n += i
        }
        for (i in a) {
            if (i == 1) { continue }
            if (i == 3) { break }
            n += i
        }
        var i = 0
        while (i < 4) {
            i += 1
            if (i == 1) { continue }
            if (i == 3) { break }
            n += i
        }
        do {
            i += 1
            if (i == 4) { continue }
            break
        } while (i < 6)
        n
    }
}

main(): Int64 {
    let a: Array<Int64> @local! = [0, 1, 2, 3]
    if (jumps(a) != 8) { return 1 }
    0
}
