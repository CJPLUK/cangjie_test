// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan IllegalArgumentException: late
// ASSERT: regex at default::main\(\)\(.*05_long_lived\.cj:20\)
// ASSERT: scan-not Thread created by:

// Delaying the exception must preserve the creator captured at spawn time.
func worker(): Unit {
    sleep(Duration.second)
    throw IllegalArgumentException("late")
}

main(): Unit {
    let f = spawn { worker() }
    try {
        f.get()
    } catch (e: Exception) {
        // The exception escaping the spawned closure has already been printed.
    }
}
