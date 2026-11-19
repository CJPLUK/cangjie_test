// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Compat mode works together with `--output-type=staticlib`.
// EXEC-PIPE: %compiler %cmp_opt -Woff unused --compat-version 1.3 %compile_lib_opt %f -o lib%n.a 2>&1 | compare %f
// ASSERT: scan-not error

func foo(): Int64 {
    return 1
}
