// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan IllegalArgumentException: boom
// ASSERT: regex at default::createWorker\(\)\(.*01_ac1_basic\.cj:21\)
// ASSERT: scan-not Thread created by:

import std.runtime.*

// An exception escaping the spawned closure is printed with its creator.
func worker(): Unit {
    throw IllegalArgumentException("boom")
}

func createWorker(): Unit {
    let f = spawn { worker() }
    try {
        f.get()
    } catch (e: Exception) {
        // The exception escaping the spawned closure has already been printed.
    }
}

main(): Unit {
    // Preserve the named creator under O2.
    blackBox(createWorker)()
}
