// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// '-o' pointing to an existing directory keeps the multi-module APC flow:
// every module is written to its own '<idx>-<name>.bc' file inside the
// directory, and no conflict warning is emitted. The source defines two
// functions so that '--apc=4' actually splits the CHIR.

// (CJNATIVE & Linux) EXEC: %mkdir outdir
// (CJNATIVE & Linux) EXEC-PIPE-0: %frontendCompiler --apc=4 -o outdir %f 2>&1 | compare %f
// ASSERT: regex-not '--apc' conflicts
// (CJNATIVE & Linux) EXEC: %ls outdir | grep -E '^[0-9]+-.*\.bc$'

func f1(): Int64 {
    return 1
}

main() {
    return f1()
}
