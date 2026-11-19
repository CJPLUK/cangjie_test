// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Compat mode must not reuse the incremental cache produced in normal mode:
// switching to compat mode triggers a full compilation (opt/llc are invoked).
// EXEC: %compiler %verbose_opt --experimental --incremental-compile %f -o %output
// EXEC-PIPE: %compiler %verbose_opt --experimental --incremental-compile --compat-version 1.3 %f -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan third_party/llvm/bin/opt
// ASSERT: scan third_party/llvm/bin/llc

main() {
    return 0
}
