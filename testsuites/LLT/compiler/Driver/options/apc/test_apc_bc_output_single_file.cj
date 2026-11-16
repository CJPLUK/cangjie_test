// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// With '-o xxx.bc', the frontend must emit exactly one valid bitcode file:
// 'llvm-dis' shall parse it and no other '.bc' file shall exist.

// (CJNATIVE & Linux) EXEC: %frontendCompiler --apc=4 -o %n.bc %f
// (CJNATIVE & Linux) EXEC: %llvmDissembler %n.bc
// (CJNATIVE & Linux) EXEC-PIPE-0: %ls -l | grep -E ' [^.]+\.bc$' | wc -l | compare %f
// ASSERT: scan 1

main() {
    return 0
}
