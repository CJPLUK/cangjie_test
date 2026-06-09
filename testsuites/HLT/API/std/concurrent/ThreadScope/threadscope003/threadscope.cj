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
    var caughtMessage = ""
    try {
        ThreadScope<Int64, Unit> {
            group =>
                group.add { 1 }
                group.add {
                    throw Exception("subtask failed")
                }
                group.add { 3 }
        }
    } catch (e: Exception) {
        caughtMessage = e.message
    }
    return if (caughtMessage == "subtask failed") { 0 } else { 1 }
}
