// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// The option may appear before the input file and before other options.
// EXEC: %compiler --compat-version 1.3 %cmp_opt -O2 %f -o %output
// EXEC: %run %run_opt %output %run_args | compare %f
// ASSERT: scan compat ok

main() {
    println("compat ok")
    return 0
}
