/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %cmp_opt %f -o %output
// (!target_win) RUN-EXEC-PIPE: export cjEnableGC=asd && %run %run_opt %output %run_args 2>&1 | compare %f
// (target_win) RUN-EXEC-PIPE: set cjEnableGC=asd&& %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan Unsupported cjEnableGC, cjEnableGC should be 0, 1 or 2.

main(): Unit {
    println("hello")
}
