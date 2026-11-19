// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan IllegalArgumentException: caught
// ASSERT: regex at default::main\(\)\(.*04_caught_print\.cj:23\)
// ASSERT: scan-not Thread created by:

// Print a caught exception on the child thread.
func worker(): Unit {
    try {
        throw IllegalArgumentException("caught")
    } catch (e: Exception) {
        e.printStackTrace()
    }
}

main(): Unit {
    let f = spawn { worker() }
    f.get()
}
