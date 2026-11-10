// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan-not Thread created by:
// ASSERT: regex \[frame\] default\.main\(\)\(.*06_get_stack_trace\.cj:24\)\s*\Z

// Print the elements returned by getStackTrace(), including the final creator frame.
func worker(): Unit {
    try {
        throw IllegalArgumentException("get")
    } catch (e: Exception) {
        for (frame in e.getStackTrace()) {
            println("[frame] ${frame}")
        }
    }
}

main(): Unit {
    let f = spawn { worker() }
    f.get()
}
