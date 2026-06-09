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

private func requireUnit(value: Unit): Unit {
    value
}

main(): Int64 {
    ThreadScope<Int64, Unit> {
        group =>
            requireUnit(group.add { 1 })
    }
    return 0
}
