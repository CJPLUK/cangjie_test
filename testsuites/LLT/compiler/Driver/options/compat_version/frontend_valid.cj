// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// cjc-frontend also accepts the option.
// EXEC-PIPE: %frontendCompiler %cmp_opt -Woff unused --compat-version 1.3 %f 2>&1 | compare %f
// ASSERT: scan-not error

main() {
    return 0
}
