// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %cmp_opt -g -O2 %f -o %output
// RUN-EXEC-PIPE-1: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan IllegalArgumentException: main boom
// ASSERT: regex at default::main\(\)\(.*03_main_thread\.cj:[0-9]+\)
// ASSERT: scan-not Thread created by:

// A main-thread exception has no spawn creator.
main(): Unit {
    throw IllegalArgumentException("main boom")
}
