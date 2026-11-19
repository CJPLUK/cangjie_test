// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Compile and run with `--compat-version=<value>`.
// EXEC: %compiler %cmp_opt %f --compat-version=1.3 -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// ASSERT: scan compat ok

main() {
    println("compat ok")
    return 0
}
