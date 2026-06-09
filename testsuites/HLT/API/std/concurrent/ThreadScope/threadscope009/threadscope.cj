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
import std.sync.*
import std.time.*

main(): Int64 {
    let taskCount = 4
    let finishedCount = AtomicInt64(0)
    var caughtMessage = ""

    try {
        ThreadScope<Int64, Unit> {
            group =>
                group.add {
                    sleep(Duration.millisecond * 20)
                    finishedCount.fetchAdd(1)
                    1
                }
                group.add {
                    sleep(Duration.millisecond * 50)
                    finishedCount.fetchAdd(1)
                    throw Exception("middle task failed")
                }
                group.add {
                    sleep(Duration.millisecond * 80)
                    finishedCount.fetchAdd(1)
                    3
                }
                group.add {
                    sleep(Duration.millisecond * 110)
                    finishedCount.fetchAdd(1)
                    4
                }
        }
    } catch (e: Exception) {
        caughtMessage = e.message
    }

    if (caughtMessage != "middle task failed") {
        return 1
    }
    return if (finishedCount.load() == Int64(taskCount)) { 0 } else { 2 }
}
