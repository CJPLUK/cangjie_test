// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// On Linux '-O0', aggressive parallel compile is enabled by default with
// '-jN'. When the user requests a single bitcode file via '-o xxx.bc' without
// an explicit '--apc', the frontend downgrades APC to 1 silently (no warning)
// and still emits one valid bitcode file.

// (CJNATIVE & Linux) EXEC-PIPE-0: %frontendCompiler -j4 -o %n.bc %f 2>&1 | compare %f
// ASSERT: regex-not '--apc' conflicts
// (CJNATIVE & Linux) EXEC: %llvmDissembler %n.bc

main() {
    return 0
}
