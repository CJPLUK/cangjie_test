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
//
// TEST INTENT: results are yielded in completion order, not launch order
// DOC REF: ThreadGroup - "Results are yielded as threads complete"
// EXPECT: collected order is 2,3,1 with 600/100/300ms delays, exit 0
// NOTE: delays are spaced 200ms+ apart so ordinary scheduler jitter
// (GC pauses, CPU contention on CI machines) cannot reorder them

import std.collection.ArrayList
import std.concurrent.*

main(): Int64 {
    let results = threadScope<Int64, ArrayList<Int64>> {
        group =>
            group.launch {
                sleep(Duration.millisecond * 600)
                1
            }
            group.launch {
                sleep(Duration.millisecond * 100)
                2
            }
            group.launch {
                sleep(Duration.millisecond * 300)
                3
            }

            let collected = ArrayList<Int64>()
            for (value in group) {
                collected.add(value)
            }
            collected
    }

    if (results.size != 3) {
        return 1
    }
    if (results[0] != 2 || results[1] != 3 || results[2] != 1) {
        return 2
    }
    return 0
}
