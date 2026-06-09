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

import std.collection.ArrayList
import std.concurrent.*
import std.time.*

main(): Int64 {
    let results = ThreadScope<Int64, ArrayList<Int64>> {
        group =>
            group.add {
                sleep(Duration.millisecond * 60)
                1
            }
            group.add {
                sleep(Duration.millisecond * 10)
                2
            }
            group.add {
                sleep(Duration.millisecond * 30)
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
