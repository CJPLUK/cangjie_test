// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan IllegalArgumentException: nested
// ASSERT: regex at default::middle\(\)\(.*02_nested_spawn\.cj:23\)
// ASSERT: scan-not Thread created by:
// ASSERT: scan-not at default::outer
// ASSERT: scan-not at default::main

import std.runtime.*

// The innermost thread records only its direct creator, middle().
func innermost(): Unit {
    throw IllegalArgumentException("nested")
}

func middle(): Unit {
    let f = spawn { innermost() }
    try {
        f.get()
    } catch (e: Exception) {
        // The exception escaping the spawned closure has already been printed.
    }
}

func outer(): Unit {
    let f = spawn { blackBox(middle)() }
    f.get()
}

main(): Unit {
    blackBox(outer)()
}
