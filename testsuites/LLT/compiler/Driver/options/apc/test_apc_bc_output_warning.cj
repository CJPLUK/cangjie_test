// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Aggressive parallel compile splits CHIR into several LLVM modules, and the
// frontend writes them into the '-o' path, which corrupts the single bitcode
// file requested by '-o xxx.bc'. The frontend now warns and falls back to
// '--apc=1'.

// (CJNATIVE & Linux) EXEC-PIPE-0: %frontendCompiler --apc=4 -o %n.bc %f 2>&1 | compare %f
// ASSERT: regex warning.*: '--apc' conflicts with '-o .*\.bc' which expects a single output file\. '--apc' is set to 1\.

main() {
    return 0
}
