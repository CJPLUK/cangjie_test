// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Allocate enough objects to force one local scope to grow across blocks.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan growth: 49995000

class Cell {
    var value: Int64
    var padding0: Int64 = 0
    var padding1: Int64 = 0
    var padding2: Int64 = 0

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

main(): Unit {
    var sum: Int64 = 0
    for (i in 0..10000) {
        let cell: Cell @local! = Cell(i) @local!
        sum += cell.value
    }
    println("growth: ${sum}")
}
