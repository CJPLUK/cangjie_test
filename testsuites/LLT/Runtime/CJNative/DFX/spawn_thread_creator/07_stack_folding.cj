// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run env CJ_SOF_SIZE=4 %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan StackOverflowError
// ASSERT: scan ... Some frames are not displayed ...
// ASSERT: scan-not Thread created by:
// ASSERT: regex at default\.main\(\)\(.*07_stack_folding\.cj:33\)

import std.runtime.*

func recurse(depth: Int64): Int64 {
    if (depth < 0) {
        return depth
    }
    // Preserve recursive calls under O2 and prevent tail-call elimination.
    return blackBox(recurse)(depth + 1) + 1
}

func worker(): Unit {
    try {
        recurse(0)
    } catch (error: StackOverflowError) {
        error.printStackTrace()
    }
}

main(): Unit {
    let f = spawn { worker() }
    f.get()
}
