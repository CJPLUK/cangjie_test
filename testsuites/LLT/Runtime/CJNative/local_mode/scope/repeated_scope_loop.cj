// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Repeatedly enter and leave a local scope to catch stack/block mismatches.
// EXEC: %compiler %local %cmp_opt %disableFuncInlining %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// ASSERT: scan repeated scopes: 4950

class LoopValue {
    var value: Int64

    exclave init(this @local!, value: Int64) {
        this.value = value
    }
}

func allocateAndRead(value: Int64): Int64 {
    let local: LoopValue @local! = LoopValue(value) @local!
    local.value
}

main(): Unit {
    var sum: Int64 = 0
    for (i in 0..100) {
        sum += allocateAndRead(i)
    }
    println("repeated scopes: ${sum}")
}
