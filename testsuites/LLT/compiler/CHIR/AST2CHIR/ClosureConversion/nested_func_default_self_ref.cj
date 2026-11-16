// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %f -o %output
// EXEC: %run %run_opt %output | compare %f

main() {
    func f(k!: Int64 = 0, g!: () -> Int64 = { => f(k: 1, g: { => 2 }) }): Int64 {
        if (k == 0) {
            g()
        } else {
            k
        }
    }
    println(f())
}

/* SCAN
1
*/
