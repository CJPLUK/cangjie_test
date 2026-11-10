// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Compiling twice in compat mode reuses the compat cache.
// EXEC: %compiler %verbose_opt --experimental --incremental-compile --compat-version 1.3 %f -o %output
// EXEC-PIPE: %compiler %verbose_opt --experimental --incremental-compile --compat-version 1.3 %f -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan-not third_party/llvm/bin/opt
// ASSERT: scan-not third_party/llvm/bin/llc

main() {
    return 0
}
