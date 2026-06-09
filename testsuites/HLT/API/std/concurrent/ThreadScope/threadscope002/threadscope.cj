/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import std.concurrent.*

main(): Int64 {
    let sum = ThreadScope<Int64, Int64> {
        group =>
            group.add { 10 }
            group.add { 20 }
            group.add { 30 }

            var total = 0
            for (value in group) {
                total += value
            }
            total
    }
    return if (sum == 60) { 0 } else { 1 }
}
