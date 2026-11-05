// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %cmp_opt -O0 %f -o %output.O0
// EXEC: %run %run_opt %output.O0 %run_args
// EXEC: %compiler %cmp_opt -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args

func check(): Int64 {
    let matrix = Array<Array<Int64>>(13, repeat: Array<Int64>(512, repeat: -1))
    for (i in 0..=12) {
        for (j in 0..=511) {
            matrix[i][j] = i + j
        }
    }

    // Keep this function above 300 basic blocks to select ActiveStatePool.
    // These loop nests evict induction-variable states across backedges.
    // A missing state at a join must not preserve an earlier constant and
    // make a loop's exit condition constant. Each nest contributes 8.
    let values = Array<Int64>(4, repeat: 0)
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    for (a in 0..=1) {
        for (b in 0..=1) {
            for (c in 0..=1) {
                values[a + b + c] += 1
            }
        }
    }
    return matrix[12][511] + values[0] + values[1] + values[2] + values[3]
}

main(): Int64 {
    // Last matrix value: 12 + 511; twelve loop nests: 12 * 8.
    return if (check() == 619) { 0 } else { 1 }
}
