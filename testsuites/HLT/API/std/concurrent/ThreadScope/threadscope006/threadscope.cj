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
    let cancellationObserved = AtomicBool(false)

    ThreadScope<Unit, Unit> {
        group =>
            group.add {
                while (!Thread.currentThread.hasPendingCancellation) {
                    sleep(Duration.millisecond * 10)
                }
                cancellationObserved.store(true)
            }

            sleep(Duration.millisecond * 50)
            group.cancelAll()
    }

    return if (cancellationObserved.load()) { 0 } else { 1 }
}
